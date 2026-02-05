      const API_BASE = 'http://localhost:5000/api';

      class API {
        constructor() {
          this.token = localStorage.getItem('token');
        }

        getHeaders() {
          return {
            'Content-Type': 'application/json',
            ...(this.token && { 'Authorization': `Bearer ${this.token}` })
          };
        }

        async request(endpoint, method = 'GET', data = null) {
          const options = {
            method,
            headers: this.getHeaders()
          };

          if (data) {
            options.body = JSON.stringify(data);
          }

          try {
            const response = await fetch(`${API_BASE}${endpoint}`, options);
            if (!response.ok && response.status === 401) {
              localStorage.removeItem('token');
              window.location.href = '/acceuil.html';
            }
            return await response.json();
          } catch (error) {
            console.error('API Error:', error);
            return { error: 'Request failed' };
          }
        }

        // === AUTH ===
        register(username, email, password) {
          return this.request('/auth/register', 'POST', { username, email, password });
        }

        login(email, password) {
          return this.request('/auth/login', 'POST', { email, password });
        }

        getMe() {
          return this.request('/auth/me');
        }

        // === BOOKS ===
        getBooks() {
          return this.request('/books');
        }

        getBook(id) {
          return this.request(`/books/${id}`);
        }

        searchBooks(query) {
          return this.request(`/books/search/${query}`);
        }

        // === RATINGS ===
        addRating(book_id, rating) {
          return this.request('/ratings/add', 'POST', { book_id, rating });
        }

        getUserRatings() {
          return this.request('/ratings/user');
        }

        // === CART ===
        getCart() {
          return this.request('/cart');
        }

        addToCart(book_id, quantity = 1) {
          return this.request('/cart/add', 'POST', { book_id, quantity });
        }

        updateCart(cart_id, quantity) {
          return this.request(`/cart/update/${cart_id}`, 'PUT', { quantity });
        }

        removeFromCart(cart_id) {
          return this.request(`/cart/remove/${cart_id}`, 'DELETE');
        }

        clearCart() {
          return this.request('/cart/clear', 'DELETE');
        }

        // === NOUVELLES METHODES RECOMMANDATIONS ===
        getRecommendationsForBook(bookId, differentCategories = false) {
          const q = differentCategories ? '?different_categories=1' : '';
          return this.request(`/recommendations/book/${bookId}${q}`);
        }

        updateRecommendationProfile(bookId, rating, action) {
          return this.request('/recommendations/update-after-rating', 'POST', {
            book_id: bookId,
            rating: rating,
            action: action
          });
        }

        updateCartRecommendationProfile(bookId) {
          return this.request('/recommendations/update-after-cart', 'POST', {
            book_id: bookId
          });
        }

        getRecommendationProfile() {
          return this.request('/recommendations/user-profile');
        }

        logInteraction(bookId, action) {
        return this.request('/recommendation-stats/log-interaction', 'POST', {
          book_id: bookId,
          action: action
        });
      }

      // AJOUTEZ CETTE MÉTHODE POUR LES RECOMMANDATIONS PERSONNALISÉES :
      getPersonalizedRecommendations() {
        return this.request('/recommendations/personalized');
      }


      // === PROFIL UTILISATEUR ===
    refreshProfile() {
      return this.request('/recommendations/refresh-profile', 'POST');
    }


    // AJOUTEZ cette méthode dans la classe API

updateUserPreferences(book_id, rating) {
  return this.request('/recommendations/update-preferences', 'POST', { 
    book_id, 
    rating 
  });
}
      }

      const api = new API();