let isLoggedIn = false;
let currentUser = null;
let userRatings = {};

// Initialize
document.addEventListener('DOMContentLoaded', async () => {
  await checkAuth();
  await loadBooks();
  setupEventListeners();
});

function setupEventListeners() {
  // Auth buttons
  document.getElementById('loginBtn').addEventListener('click', openAuthModal);
  document.getElementById('logoutBtn').addEventListener('click', logout);
  document.getElementById('profileBtn').addEventListener('click', showUserProfile);
  
  // Auth modal
  document.getElementById('toggleRegister').addEventListener('click', (e) => {
    e.preventDefault();
    document.getElementById('authForm').style.display = 'none';
    document.getElementById('registerForm').style.display = 'block';
  });

  document.getElementById('toggleLogin').addEventListener('click', (e) => {
    e.preventDefault();
    document.getElementById('registerForm').style.display = 'none';
    document.getElementById('authForm').style.display = 'block';
  });

  document.getElementById('loginFormBtn').addEventListener('click', loginUser);
  document.getElementById('registerFormBtn').addEventListener('click', registerUser);

  // Cart
  document.getElementById('cartBtn').addEventListener('click', openCartModal);
  document.getElementById('checkoutBtn').addEventListener('click', checkout);

  // Search
  document.getElementById('searchInput').addEventListener('input', (e) => {
    const query = e.target.value;
    if (query.length > 2) {
      searchBooks(query);
    } else {
      loadBooks();
    }
  });

  // Modal close
  document.querySelectorAll('.close').forEach(btn => {
    btn.addEventListener('click', (e) => {
      e.target.closest('.modal').classList.remove('show');
    });
  });

  window.addEventListener('click', (e) => {
    if (e.target.classList.contains('modal')) {
      e.target.classList.remove('show');
    }
  });
}

async function checkAuth() {
  const token = localStorage.getItem('token');
  if (token) {
    const result = await api.getMe();
    if (result.user) {
      isLoggedIn = true;
      currentUser = result.user;
      updateAuthUI();
      await loadUserRatings();
      await loadRecommendations();
      await updateCartCount();
    } else {
      localStorage.removeItem('token');
      api.token = null;
    }
  }
}

function updateAuthUI() {
  const loginBtn = document.getElementById('loginBtn');
  const logoutBtn = document.getElementById('logoutBtn');
  const profileBtn = document.getElementById('profileBtn');

  if (isLoggedIn) {
    loginBtn.style.display = 'none';
    logoutBtn.style.display = 'inline-block';
    profileBtn.style.display = 'inline-block';
  } else {
    loginBtn.style.display = 'inline-block';
    logoutBtn.style.display = 'none';
    profileBtn.style.display = 'none';
  }
}

async function showUserProfile(e) {
  e.preventDefault();
  
  if (!isLoggedIn) {
    alert('Veuillez vous connecter');
    return;
  }

  try {
    const profile = await api.getRecommendationProfile();
    
    const modalHTML = `
      <div class="profile-modal">
        <div class="profile-content">
          <button class="close-profile">&times;</button>
          <h2>Votre Profil de Lecture</h2>
          
          <div class="profile-stats">
            <div class="stat-item">
              <h3>Interactions</h3>
              <p class="stat-value">${profile.stats?.total_interactions || 0}</p>
            </div>
            <div class="stat-item">
              <h3>Livres uniques</h3>
              <p class="stat-value">${profile.stats?.unique_books || 0}</p>
            </div>
            <div class="stat-item">
              <h3>Engagement</h3>
              <p class="stat-value">${profile.engagement_score || 0}%</p>
            </div>
          </div>
          
          ${profile.favorite_categories && profile.favorite_categories.length > 0 ? `
            <div class="profile-section">
              <h3>Vos catégories préférées</h3>
              <div class="categories-list">
                ${profile.favorite_categories.map(cat => `
                  <span class="category-tag">Catégorie ${cat.category_id}</span>
                `).join('')}
              </div>
            </div>
          ` : ''}
          
          ${profile.top_ratings && profile.top_ratings.length > 0 ? `
            <div class="profile-section">
              <h3>Vos meilleures notes</h3>
              <ul class="ratings-list">
                ${profile.top_ratings.slice(0, 5).map(rating => `
                  <li><strong>${rating.title}</strong> - ${rating.rating}/5</li>
                `).join('')}
              </ul>
            </div>
          ` : ''}
          
          <div class="profile-actions">
            <button class="btn-primary" onclick="refreshRecommendations()">
              Refresh recommendations
            </button>
            <button class="btn-secondary" id="viewRecommendationsBtn">
              Voir les recommandations
            </button>
          </div>
          
          <div class="last-update">
            <small>Dernière mise à jour: ${new Date().toLocaleString()}</small>
          </div>
        </div>
      </div>
    `;
    
    const modalContainer = document.createElement('div');
    modalContainer.id = 'profileModal';
    modalContainer.innerHTML = modalHTML;
    document.body.appendChild(modalContainer);
    
    modalContainer.style.display = 'block';
    
    modalContainer.querySelector('.close-profile').addEventListener('click', () => {
      modalContainer.remove();
    });
    
    modalContainer.querySelector('#viewRecommendationsBtn').addEventListener('click', () => {
      modalContainer.remove();
      
      setTimeout(() => {
        const recommendationsSection = document.getElementById('recommendationsSection');
        if (recommendationsSection) {
          recommendationsSection.style.display = 'block';
          loadRecommendations();
          recommendationsSection.scrollIntoView({ 
            behavior: 'smooth', 
            block: 'start' 
          });
          showNotification('Affichage de vos recommandations personnalisées', 'info');
        } else {
          showNotification('Section recommandations introuvable', 'error');
        }
      }, 300);
    });
    
    modalContainer.addEventListener('click', (e) => {
      if (e.target === modalContainer) {
        modalContainer.remove();
      }
    });
    
  } catch (error) {
    console.error('Erreur chargement profil:', error);
    showNotification('Impossible de charger votre profil', 'error');
  }
}

async function refreshRecommendations() {
  if (!isLoggedIn) {
    showNotification('Please log in to refresh recommendations', 'error');
    return;
  }
  
  showNotification('Updating recommendations...', 'info');
  
  try {
    console.log('🔄 Début du rafraîchissement des recommandations');
    
    const response = await api.refreshProfile();
    
    if (response.error) {
      console.error('Erreur API:', response.error);
      throw new Error(response.error || 'Erreur serveur');
    }
    
    console.log('✅ Réponse du rafraîchissement:', response);
    
    if (response.recommendations && response.recommendations.length > 0) {
      console.log(`🎯 ${response.recommendations.length} nouvelles recommandations`);
      
      const personalizedRecs = response.recommendations.map(rec => ({
        ...rec,
        recommended: true,
        reason: rec.reason || 'Recommandé selon vos goûts'
      }));
      
      displayBooks(personalizedRecs, 'recommendationsList');
      document.getElementById('recommendationsSection').style.display = 'block';
      
      showNotification(personalizedRecs.length + ' recommendations updated', 'success');
    } else {
      console.log('⚠️ Aucune nouvelle recommandation');
      showNotification('No new recommendations available', 'info');
    }
    
    const modal = document.getElementById('profileModal');
    if (modal) {
      modal.remove();
      setTimeout(async () => {
        await showUserProfile({ preventDefault: () => {} });
      }, 1000);
    }
    
  } catch (error) {
    console.error('❌ Erreur rafraîchissement:', error);
    showNotification('Erreur lors de la mise à jour des recommandations', 'error');
  }
}

function openAuthModal() {
  document.getElementById('authForm').style.display = 'block';
  document.getElementById('registerForm').style.display = 'none';
  document.getElementById('authModal').classList.add('show');
}

async function loginUser() {
  const email = document.getElementById('email').value;
  const password = document.getElementById('password').value;

  if (!email || !password) {
    alert('Veuillez remplir tous les champs');
    return;
  }

  const result = await api.login(email, password);

  if (result.error) {
    alert(result.error);
  } else {
    localStorage.setItem('token', result.token);
    api.token = result.token;
    isLoggedIn = true;
    currentUser = result.user;
    updateAuthUI();
    await loadUserRatings();
    await loadRecommendations();
    await updateCartCount();
    document.getElementById('authModal').classList.remove('show');
    document.getElementById('email').value = '';
    document.getElementById('password').value = '';
    showNotification('Welcome ' + currentUser.username, 'success');
  }
}

function showNotification(message, type = 'success') {
  const existingNotification = document.querySelector('.notification');
  if (existingNotification) {
    existingNotification.remove();
  }
  
  const notification = document.createElement('div');
  notification.className = `notification ${type}`;
  notification.textContent = message;
  notification.style.cssText = `
    position: fixed;
    top: 20px;
    right: 20px;
    padding: 15px 25px;
    background: ${type === 'success' ? '#4CAF50' : '#f44336'};
    color: white;
    border-radius: 8px;
    z-index: 10000;
    animation: slideIn 0.3s ease;
    font-family: 'Poppins', sans-serif;
    font-weight: 500;
    box-shadow: 0 4px 12px rgba(0,0,0,0.15);
    max-width: 300px;
  `;
  
  document.body.appendChild(notification);
  
  setTimeout(() => {
    notification.style.animation = 'slideOut 0.3s ease';
    setTimeout(() => notification.remove(), 300);
  }, 3000);
}

async function registerUser() {
  const username = document.getElementById('username').value;
  const email = document.getElementById('regEmail').value;
  const password = document.getElementById('regPassword').value;

  if (!username || !email || !password) {
    alert('Veuillez remplir tous les champs');
    return;
  }

  const result = await api.register(username, email, password);

  if (result.error) {
    alert(result.error);
  } else {
    showNotification('Account created. Please log in.', 'success');
    document.getElementById('registerForm').style.display = 'none';
    document.getElementById('authForm').style.display = 'block';
    document.getElementById('username').value = '';
    document.getElementById('regEmail').value = '';
    document.getElementById('regPassword').value = '';
  }
}

function logout() {
  localStorage.removeItem('token');
  api.token = null;
  isLoggedIn = false;
  currentUser = null;
  userRatings = {};
  updateAuthUI();
  showNotification('Goodbye', 'info');
  setTimeout(() => {
    location.reload();
  }, 1000);
}

async function loadBooks() {
  try {
    console.log('Chargement des livres...');
    const books = await api.getBooks();
    console.log('Livres reçus:', books);
    displayBooks(books, 'booksList');
  } catch (error) {
    console.error('Erreur lors du chargement des livres:', error);
    const container = document.getElementById('booksList');
    container.innerHTML = '<p style="grid-column: 1/-1; text-align: center; padding: 40px; color: #f44336;">Erreur de chargement des livres. Veuillez réessayer.</p>';
  }
}

async function searchBooks(query) {
  try {
    console.log('Recherche de:', query);
    const books = await api.searchBooks(query);
    console.log('Résultats de recherche:', books);
    displayBooks(books, 'booksList');
  } catch (error) {
    console.error('Erreur de recherche:', error);
  }
}

async function loadIntelligentRecommendations() {
  if (!isLoggedIn) {
    console.log('⚠️ Utilisateur non connecté, pas de recommandations');
    return;
  }
  
  try {
    console.log('🧠 Chargement des recommandations intelligentes pour user', currentUser.id);
    
    const response = await fetch(`http://localhost:5002/intelligent-recommendations/${currentUser.id}`);
    const data = await response.json();
    
    console.log('📦 Réponse API intelligente:', data);
    
    if (data.status === 'success') {
      if (data.recommendations && data.recommendations.length > 0) {
        console.log(`✅ ${data.recommendations.length} recommandations intelligentes reçues`);
        
        const intelligentRecs = data.recommendations.map(rec => ({
          ...rec,
          recommended: true,
          reason: rec.reason || 'Recommandé selon vos goûts',
          category_name: 'Livre',
          algorithm: data.algorithm || 'intelligent'
        }));
        
        displayBooks(intelligentRecs, 'recommendationsList');
        document.getElementById('recommendationsSection').style.display = 'block';
        
        return;
      } else {
        console.warn('⚠️ API intelligente retourne 0 recommandations:', data.message);
      }
    } else {
      console.error('❌ Erreur API intelligente:', data.message);
    }
    
    console.log('🔄 Tentative avec recommandations personnalisées Node.js');
    try {
      const personalized = await api.getPersonalizedRecommendations();
      if (personalized && personalized.length > 0) {
        console.log(`✅ ${personalized.length} recommandations personnalisées reçues`);
        displayBooks(personalized, 'recommendationsList');
        document.getElementById('recommendationsSection').style.display = 'block';
        return;
      }
    } catch (nodeError) {
      console.error('❌ Erreur recommandations Node.js:', nodeError);
    }
    
    console.log('🔄 Utilisation des livres populaires');
    const allBooks = await api.getBooks();
    if (allBooks && allBooks.length > 0) {
      const popularBooks = allBooks
        .slice(0, 8)
        .map(book => ({
          ...book,
          recommended: true,
          reason: 'Livre populaire de notre collection'
        }));
      
      displayBooks(popularBooks, 'recommendationsList');
      document.getElementById('recommendationsSection').style.display = 'block';
    } else {
      const recommendationsList = document.getElementById('recommendationsList');
      recommendationsList.innerHTML = `
        <div class="no-recommendations-message">
          <h3>Pas encore de recommandations</h3>
          <p>Notez quelques livres pour recevoir des recommandations personnalisées !</p>
          <button class="btn-primary" onclick="loadBooks()">Voir tous les livres</button>
        </div>
      `;
      document.getElementById('recommendationsSection').style.display = 'block';
    }
    
  } catch (error) {
    console.error('❌ Erreur chargement recommandations intelligentes:', error);
    
    const recommendationsList = document.getElementById('recommendationsList');
    recommendationsList.innerHTML = `
      <div class="error-message">
        <h3>Service temporairement indisponible</h3>
        <p>Les recommandations personnalisées seront bientôt de retour.</p>
        <button class="btn-secondary" onclick="location.reload()">Réessayer</button>
      </div>
    `;
  }
}

// FONCTION PRINCIPALE pour afficher les livres (section "Tous les livres" et "Recommandations")
function displayBooks(books, containerId) {
  console.log('Affichage des livres dans', containerId, ':', books);
  const container = document.getElementById(containerId);
  
  if (!container) {
    console.error('Conteneur non trouvé:', containerId);
    return;
  }
  
  container.innerHTML = '';

  if (!Array.isArray(books) || books.length === 0) {
    container.innerHTML = '<p style="grid-column: 1/-1; text-align: center; padding: 40px;">Aucun livre trouvé</p>';
    return;
  }

  books.forEach(book => {
    const rating = userRatings[book.id] || 0;
    const bookCard = document.createElement('div');
    bookCard.className = 'book-card';
    bookCard.innerHTML = `
      <div class="book-cover">
        <img src="${book.image_url || 'https://via.placeholder.com/300x400?text=' + encodeURIComponent(book.title)}" alt="${book.title}" onerror="this.src='https://via.placeholder.com/300x400?text=Image+non+disponible'">
        <span class="badge">${book.category_name || 'Livre'}</span>
      </div>
      <div class="book-info">
        <h3>${book.title || 'Titre inconnu'}</h3>
        <p class="book-author">Par ${book.author || 'Auteur inconnu'}</p>
        <div class="stars" data-book-id="${book.id}">
          ${[1, 2, 3, 4, 5].map(i => `
            <span class="star ${i <= rating ? 'active' : ''}" data-rating="${i}">★</span>
          `).join('')}
        </div>
        <div class="book-footer">
          <span class="book-price">$${parseFloat(book.price || 0).toFixed(2)}</span>
          <button class="add-to-cart" data-id="${book.id}" title="Ajouter au panier">+</button>
        </div>
      </div>
    `;

    // Rating clicks - VERSION AVEC MESSAGE "Mise à jour de vos préférences"
    bookCard.querySelectorAll('.star').forEach(star => {
      star.addEventListener('click', async (e) => {
        if (!isLoggedIn) {
          alert('Veuillez vous connecter pour évaluer');
          return;
        }
        
        const rating = parseInt(e.target.dataset.rating);
        const bookId = parseInt(e.target.closest('.stars').dataset.bookId);
        
        console.log(`⭐ Évaluation PRINCIPALE: livre ${bookId}, note ${rating}`);
        
        const originalHTML = bookCard.innerHTML;
        
        try {
          // Afficher un indicateur de chargement
          bookCard.innerHTML = '<div class="loading">Mise à jour de vos préférences...</div>';
          
          // 1. Sauvegarder l'évaluation
          await api.addRating(bookId, rating);
          
          // 2. Mettre à jour le profil de recommandation
          await api.updateRecommendationProfile(bookId, rating, 'rating');
          
          // 3. Mettre à jour les préférences
          try {
            await api.request('/recommendations/update-preferences', 'POST', {
              book_id: bookId,
              rating: rating
            });
          } catch (prefError) {
            console.warn('⚠️ Avertissement préférences:', prefError);
          }
          
          // 4. Logger l'interaction
          await api.logInteraction(bookId, 'rating');
          
          // 5. Mettre à jour le cache
          userRatings[bookId] = rating;
          
          // 6. Recharger les livres et recommandations
          setTimeout(async () => {
            await loadBooks();
            await loadRecommendations();
            
            showNotification('Preferences updated', 'success');
          }, 500);
          
        } catch (error) {
          console.error('❌ Erreur évaluation principale:', error);
          bookCard.innerHTML = originalHTML;
          showNotification('Évaluation enregistrée (erreur technique mineure)', 'info');
        }
      });
    });

    // ADD TO CART - then show "You might like this" recommendations
    bookCard.querySelector('.add-to-cart').addEventListener('click', async (e) => {
      e.stopPropagation();
      
      if (!isLoggedIn) {
        alert('Please log in to add to cart');
        openAuthModal();
        return;
      }

      const btnBookId = parseInt(e.target.dataset.id);
      const btn = e.target;
      const originalText = btn.textContent;
      
      btn.disabled = true;
      btn.textContent = '...';
      
      const result = await api.addToCart(btnBookId, 1);

      if (!result.error) {
        await updateCartCount();
        animateCartCounter();
        showNotification('Added to cart', 'success');
        await api.updateCartRecommendationProfile(btnBookId);
        showYouMightLikeModal(btnBookId);
      } else {
        showNotification('Error adding to cart', 'error');
      }
      
      btn.textContent = originalText;
      btn.disabled = false;
    });

    container.appendChild(bookCard);
  });
  
  console.log('Livres affichés avec succès');
}

// Fonction pour animer le compteur panier
function animateCartCounter() {
  const cartCount = document.getElementById('cartCount');
  const currentCount = parseInt(cartCount.textContent) || 0;
  
  cartCount.style.transform = 'scale(1.5)';
  cartCount.style.color = '#4CAF50';
  cartCount.style.fontWeight = 'bold';
  
  setTimeout(() => {
    cartCount.style.transform = 'scale(1)';
    setTimeout(() => {
      cartCount.style.color = '';
      cartCount.style.fontWeight = '';
    }, 300);
  }, 300);
}

async function loadRecommendations() {
  if (!isLoggedIn) {
    document.getElementById('recommendationsSection').style.display = 'none';
    return;
  }

  try {
    await loadIntelligentRecommendations();
    
  } catch (error) {
    console.error('Erreur chargement recommandations:', error);
    const recommendationsList = document.getElementById('recommendationsList');
    recommendationsList.innerHTML = '<p style="grid-column: 1/-1; text-align: center; padding: 40px;">Chargement des recommandations...</p>';
    
    const allBooks = await api.getBooks();
    const popularBooks = allBooks
      .filter(book => book.average_rating > 0)
      .sort((a, b) => (b.average_rating || 0) - (a.average_rating || 0))
      .slice(0, 8)
      .map(book => ({
        ...book,
        recommended: true,
        reason: 'Livre populaire'
      }));
    
    displayBooks(popularBooks, 'recommendationsList');
  }
}

async function showYouMightLikeModal(bookId) {
  const quickRecContainer = document.getElementById('quickRecommendations');
  quickRecContainer.innerHTML = '<div class="loading">Loading recommendations...</div>';
  document.getElementById('recommendationModal').classList.add('show');

  try {
    const recommendations = await api.getRecommendationsForBook(bookId);
    if (!Array.isArray(recommendations) || recommendations.length === 0) {
      quickRecContainer.innerHTML = '<p class="no-recommendations">No recommendations available</p>';
      setupRecoModalButtons();
      return;
    }
    displayYouMightLikeBooks(recommendations, 'quickRecommendations');
    setupRecoModalButtons();
  } catch (error) {
    quickRecContainer.innerHTML = '<p class="error">Could not load recommendations</p>';
    setupRecoModalButtons();
  }
}

function setupRecoModalButtons() {
  const modal = document.getElementById('recommendationModal');
  const closeBtn = document.getElementById('closeRecoModal');
  const skipBtn = document.getElementById('skipRecoBtn');
  const nextBtn = document.getElementById('nextToCartBtn');

  function closeModal() {
    modal.classList.remove('show');
  }

  if (closeBtn) closeBtn.onclick = closeModal;
  if (skipBtn) skipBtn.onclick = closeModal;
  if (nextBtn) {
    nextBtn.onclick = () => {
      closeModal();
      openCartModal();
    };
  }
}

function displayYouMightLikeBooks(books, containerId) {
  const container = document.getElementById(containerId);
  if (!container) return;
  container.innerHTML = '';

  if (!Array.isArray(books) || books.length === 0) {
    container.innerHTML = '<p class="no-recommendations">No recommendations available</p>';
    return;
  }

  books.forEach(book => {
    const bookCard = document.createElement('div');
    bookCard.className = 'book-card reco-card';
    bookCard.innerHTML = `
      <div class="book-cover">
        <img src="${book.image_url || 'https://via.placeholder.com/300x400?text=Book'}" alt="${book.title}" onerror="this.src='https://via.placeholder.com/300x400?text=Book'">
        <span class="badge">${book.category_name || (book.reason ? book.reason.replace('Same category: ', '') : 'Same category')}</span>
      </div>
      <div class="book-info">
        <h3>${book.title || 'Unknown'}</h3>
        <p class="book-author">${book.author || 'Unknown author'}</p>
        <div class="book-footer">
          <span class="book-price">$${parseFloat(book.price || 0).toFixed(2)}</span>
          <button class="add-to-cart reco-add-btn" data-id="${book.id}" title="Add to cart">+</button>
        </div>
      </div>
    `;

    bookCard.querySelector('.add-to-cart').addEventListener('click', async (e) => {
      e.stopPropagation();
      if (!isLoggedIn) {
        alert('Please log in to add to cart');
        return;
      }
      const btnBookId = parseInt(e.target.dataset.id);
      const btn = e.target;
      btn.disabled = true;
      btn.textContent = '...';
      const result = await api.addToCart(btnBookId, 1);
      if (!result.error) {
        await updateCartCount();
        animateCartCounter();
        showNotification('Added to cart', 'success');
        btn.textContent = 'OK';
      } else {
        showNotification('Error', 'error');
        btn.textContent = '+';
      }
      btn.disabled = false;
    });

    container.appendChild(bookCard);
  });
}

// FONCTION SPÉCIALE POUR LE MODAL - Sans message "Mise à jour de vos préférences"
function displayModalBooks(books, containerId) {
  console.log('Affichage des livres MODAL dans', containerId, ':', books);
  const container = document.getElementById(containerId);
  
  if (!container) {
    console.error('Conteneur modal non trouvé:', containerId);
    return;
  }
  
  container.innerHTML = '';

  if (!Array.isArray(books) || books.length === 0) {
    container.innerHTML = '<p style="grid-column: 1/-1; text-align: center; padding: 40px;">Aucun livre trouvé</p>';
    return;
  }

  books.forEach(book => {
    const rating = userRatings[book.id] || 0;
    const bookCard = document.createElement('div');
    bookCard.className = 'book-card';
    bookCard.innerHTML = `
      <div class="book-cover">
        <img src="${book.image_url || 'https://via.placeholder.com/300x400?text=' + encodeURIComponent(book.title)}" alt="${book.title}" onerror="this.src='https://via.placeholder.com/300x400?text=Image+non+disponible'">
        <span class="badge">${book.category_name || 'Livre'}</span>
      </div>
      <div class="book-info">
        <h3>${book.title || 'Titre inconnu'}</h3>
        <p class="book-author">Par ${book.author || 'Auteur inconnu'}</p>
        <div class="stars" data-book-id="${book.id}">
          ${[1, 2, 3, 4, 5].map(i => `
            <span class="star ${i <= rating ? 'active' : ''}" data-rating="${i}">★</span>
          `).join('')}
        </div>
        <div class="book-footer">
          <span class="book-price">$${parseFloat(book.price || 0).toFixed(2)}</span>
          <button class="add-to-cart" data-id="${book.id}" title="Ajouter au panier">+</button>
        </div>
      </div>
    `;

    // Rating clicks - VERSION MODALE SIMPLIFIÉE
    attachModalStarEvents(bookCard, book.id);

    // AJOUT AU PANIER
    bookCard.querySelector('.add-to-cart').addEventListener('click', async (e) => {
      e.stopPropagation();
      
      if (!isLoggedIn) {
        alert('Veuillez vous connecter pour ajouter au panier');
        openAuthModal();
        return;
      }

      const btnBookId = parseInt(e.target.dataset.id);
      const btn = e.target;
      const originalText = btn.textContent;
      
      btn.disabled = true;
      btn.textContent = 'OK';
      btn.style.background = '#4CAF50';
      btn.style.color = 'white';
      
      const result = await api.addToCart(btnBookId, 1);

      if (!result.error) {
        await updateCartCount();
        animateCartCounter();
        showNotification('Added to cart', 'success');
        await api.updateCartRecommendationProfile(btnBookId);
      } else {
        btn.textContent = '+';
        btn.style.background = '#f44336';
        showNotification('Error adding to cart', 'error');
      }
      
      setTimeout(() => {
        btn.textContent = originalText;
        btn.style.background = '';
        btn.style.color = '';
        btn.disabled = false;
      }, 1500);
    });

    // CLIC SUR LA CARTE dans le modal - NE RIEN FAIRE
    bookCard.addEventListener('click', (e) => {
      if (e.target.classList.contains('add-to-cart') || 
          e.target.classList.contains('star') || 
          e.target.closest('.stars') || 
          e.target.closest('.add-to-cart')) {
        return;
      }
    });

    container.appendChild(bookCard);
  });
  
  console.log('Livres MODAL affichés avec succès');
}

// Fonction utilitaire pour attacher les événements aux étoiles dans le modal
function attachModalStarEvents(bookCard, bookId) {
  bookCard.querySelectorAll('.star').forEach(star => {
    star.addEventListener('click', async (e) => {
      if (!isLoggedIn) {
        alert('Veuillez vous connecter pour évaluer');
        return;
      }
      
      const rating = parseInt(e.target.dataset.rating);
      
      console.log(`⭐ Évaluation MODAL: livre ${bookId}, note ${rating}`);
      
      try {
        // Sauvegarder l'évaluation simplement
        await api.addRating(bookId, rating);
        
        // Mettre à jour le profil de recommandation
        await api.updateRecommendationProfile(bookId, rating, 'rating');
        
        // Mettre à jour les préférences
        try {
          await api.request('/recommendations/update-preferences', 'POST', {
            book_id: bookId,
            rating: rating
          });
        } catch (prefError) {
          console.warn('⚠️ Avertissement préférences:', prefError);
        }
        
        // Mettre à jour le cache
        userRatings[bookId] = rating;
        
        // Mettre à jour l'affichage des étoiles
        const stars = bookCard.querySelectorAll('.star');
        stars.forEach((s, index) => {
          if (index + 1 <= rating) {
            s.classList.add('active');
          } else {
            s.classList.remove('active');
          }
        });
        
        showNotification('Rating saved', 'success');
        
        // Rafraîchir les recommandations principales
        setTimeout(() => {
          loadRecommendations();
        }, 800);
        
      } catch (error) {
        console.error('❌ Erreur évaluation modal:', error);
        showNotification('Erreur lors de l\'enregistrement', 'error');
      }
    });
  });
}

async function loadUserRatings() {
  if (!isLoggedIn) return;
  try {
    const ratings = await api.getUserRatings();
    userRatings = {};
    ratings.forEach(r => {
      userRatings[r.book_id] = r.rating;
    });
  } catch (error) {
    console.error('Erreur chargement évaluations:', error);
  }
}

async function openCartModal() {
  if (!isLoggedIn) {
    alert('Veuillez vous connecter pour voir votre panier');
    openAuthModal();
    return;
  }

  try {
    const cart = await api.getCart();
    const cartItemsDiv = document.getElementById('cartItems');
    cartItemsDiv.innerHTML = '';

    if (!Array.isArray(cart) || cart.length === 0) {
      cartItemsDiv.innerHTML = '<p>Your cart is empty</p>';
      document.getElementById('checkoutBtn').disabled = true;
      document.getElementById('totalPrice').textContent = '0.00';
    } else {
      let total = 0;
      cart.forEach(item => {
        const subtotal = item.price * item.quantity;
        total += subtotal;

        const cartItem = document.createElement('div');
        cartItem.className = 'cart-item';
        cartItem.innerHTML = `
          <div class="item-info">
            <img src="${item.image_url || 'https://via.placeholder.com/70x95?text=Livre'}" alt="${item.title}">
            <div>
              <h4>${item.title}</h4>
              <p>$${parseFloat(item.price).toFixed(2)} x 
                <input type="number" value="${item.quantity}" min="1" class="qty-input" data-cart-id="${item.id}">
              </p>
            </div>
          </div>
          <div class="item-actions">
            <p>$${subtotal.toFixed(2)}</p>
            <button class="remove-btn" data-cart-id="${item.id}">Remove</button>
          </div>
        `;

        cartItem.querySelector('.qty-input').addEventListener('change', async (e) => {
          const newQty = parseInt(e.target.value);
          if (newQty > 0) {
            await api.updateCart(item.id, newQty);
            openCartModal();
            showNotification('Quantity updated', 'info');
          }
        });

        cartItem.querySelector('.remove-btn').addEventListener('click', async () => {
          await api.removeFromCart(item.id);
          openCartModal();
          await updateCartCount();
          showNotification('Item removed', 'info');
        });

        cartItemsDiv.appendChild(cartItem);
      });

      document.getElementById('totalPrice').textContent = total.toFixed(2);
      document.getElementById('checkoutBtn').disabled = false;
    }

    document.getElementById('cartModal').classList.add('show');
  } catch (error) {
    console.error('Erreur ouverture panier:', error);
    alert('Error loading cart');
  }
}

async function updateCartCount() {
  if (!isLoggedIn) {
    document.getElementById('cartCount').textContent = '0';
    return;
  }
  
  try {
    const cart = await api.getCart();
    const count = Array.isArray(cart) ? cart.reduce((sum, item) => sum + item.quantity, 0) : 0;
    document.getElementById('cartCount').textContent = count;
    console.log('Compteur panier mis à jour:', count);
  } catch (error) {
    console.error('Erreur chargement panier:', error);
    document.getElementById('cartCount').textContent = '0';
  }
}

function checkout() {
  if (confirm('Confirm order?')) {
    api.clearCart();
    document.getElementById('cartModal').classList.remove('show');
    updateCartCount();
    showNotification('Order confirmed. Thank you.', 'success');
  }
}

// Ajouter les animations CSS manquantes
document.addEventListener('DOMContentLoaded', function() {
  const style = document.createElement('style');
  style.textContent = `
    @keyframes slideIn {
      from { transform: translateX(100%); opacity: 0; }
      to { transform: translateX(0); opacity: 1; }
    }
    
    @keyframes slideOut {
      from { transform: translateX(0); opacity: 1; }
      to { transform: translateX(100%); opacity: 0; }
    }
    
    #cartCount {
      transition: all 0.3s ease;
      display: inline-block;
      min-width: 20px;
      text-align: center;
    }
    
    .loading {
      text-align: center;
      padding: 40px;
      color: #666;
      font-size: 16px;
      grid-column: 1/-1;
    }
    
    .no-recommendations, .error {
      text-align: center;
      padding: 40px;
      color: #666;
      font-size: 16px;
      grid-column: 1/-1;
    }
  `;
  document.head.appendChild(style);
});