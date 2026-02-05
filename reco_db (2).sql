-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : jeu. 05 fév. 2026 à 14:44
-- Version du serveur : 10.4.32-MariaDB
-- Version de PHP : 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `reco_db`
--

-- --------------------------------------------------------

--
-- Structure de la table `books`
--

CREATE TABLE `books` (
  `id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `author` varchar(150) NOT NULL,
  `category_id` int(11) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `stock` int(11) DEFAULT 0,
  `image_url` varchar(500) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `books`
--

INSERT INTO `books` (`id`, `title`, `author`, `category_id`, `price`, `stock`, `image_url`, `description`, `created_at`) VALUES
(1, 'Le Petit Prince', 'Antoine de Saint-Exupéry', 3, 12.90, 50, 'https://covers.openlibrary.org/b/id/10523364-L.jpg', 'Un conte philosophique et poétique sur l\'amitié et l\'amour', '2026-01-28 16:01:37'),
(2, '1984', 'George Orwell', 4, 10.90, 35, 'https://covers.openlibrary.org/b/id/7222246-L.jpg', 'Un roman dystopique sur un régime totalitaire', '2026-01-28 16:01:37'),
(3, 'Candide', 'Voltaire', 1, 8.50, 40, 'https://covers.openlibrary.org/b/id/8231998-L.jpg', 'Conte philosophique sur l\'optimisme', '2026-01-28 16:01:37'),
(4, 'Les Misérables', 'Victor Hugo', 1, 15.99, 25, 'https://covers.openlibrary.org/b/id/8235688-L.jpg', 'Épopée du 19e siècle racontant l\'histoire de Jean Valjean', '2026-01-28 16:01:37'),
(5, 'Orgeuil et Préjugés', 'Jane Austen', 1, 11.99, 30, 'https://covers.openlibrary.org/b/id/7769809-L.jpg', 'Roman d\'amour et de société dans l\'Angleterre du 19e siècle', '2026-01-28 16:01:37'),
(6, 'Fondation', 'Isaac Asimov', 4, 13.90, 20, 'https://covers.openlibrary.org/b/id/234214-L.jpg', 'Premier tome de la célèbre série de science-fiction', '2026-01-28 16:01:37'),
(7, 'La Révolution Française', 'Jean-Claude Damamme', 5, 14.50, 15, 'https://covers.openlibrary.org/b/id/8392123-L.jpg', 'Étude approfondie de la Révolution Française', '2026-01-28 16:01:37'),
(8, 'Harry Potter à l\'École des Sorciers', 'J.K. Rowling', 3, 9.99, 60, 'https://covers.openlibrary.org/b/id/8241167-L.jpg', 'Aventures magiques d\'un jeune sorcier', '2026-01-28 16:01:37'),
(9, 'Dune', 'Frank Herbert', 4, 18.99, 18, 'https://covers.openlibrary.org/b/id/7738555-L.jpg', 'Épopée science-fiction sur la planète Arrakis', '2026-01-28 16:01:37'),
(10, 'L\'Alchimiste', 'Paulo Coelho', 1, 10.50, 45, 'https://covers.openlibrary.org/b/id/8353849-L.jpg', 'Récit inspirant sur la quête personnelle', '2026-01-28 16:01:37'),
(11, 'La Métamorphose', 'Franz Kafka', 1, 9.99, 25, 'https://covers.openlibrary.org/b/id/12345-L.jpg', 'Nouvelle fantastique', '2026-01-28 16:01:47'),
(12, 'Crime et Châtiment', 'Fiodor Dostoïevski', 1, 14.99, 20, 'https://covers.openlibrary.org/b/id/12346-L.jpg', 'Roman psychologique classique', '2026-01-28 16:01:47'),
(13, 'L\'Odeur de la Pluie', 'Petros Markaris', 1, 11.99, 30, 'https://covers.openlibrary.org/b/id/12347-L.jpg', 'Polar méditerranéen', '2026-01-28 16:01:47'),
(14, 'Fondation et Empire', 'Isaac Asimov', 4, 13.90, 18, 'https://covers.openlibrary.org/b/id/12348-L.jpg', 'Suite de la série Fondation', '2026-01-28 16:01:47'),
(15, 'Le Seigneur des Anneaux', 'J.R.R. Tolkien', 4, 19.99, 35, 'https://covers.openlibrary.org/b/id/12349-L.jpg', 'Épopée fantastique classique', '2026-01-28 16:01:47'),
(51, 'L\'Étranger', 'Albert Camus', 1, 10.99, 30, 'https://covers.openlibrary.org/b/id/8231996-L.jpg', 'Roman philosophique sur l’absurdité de la condition humaine', '2026-01-29 23:22:21'),
(52, 'La Peste', 'Albert Camus', 1, 12.50, 25, 'https://covers.openlibrary.org/b/id/8228691-L.jpg', 'Allégorie de la résistance humaine face au mal', '2026-01-29 23:22:21'),
(53, 'Le Comte de Monte-Cristo', 'Alexandre Dumas', 1, 15.99, 20, 'https://covers.openlibrary.org/b/id/8235116-L.jpg', 'Roman d’aventure et de vengeance', '2026-01-29 23:22:21'),
(54, 'Madame Bovary', 'Gustave Flaubert', 1, 11.50, 30, 'https://covers.openlibrary.org/b/id/8232083-L.jpg', 'Portrait réaliste de la société bourgeoise', '2026-01-29 23:22:21'),
(55, 'Don Quichotte', 'Miguel de Cervantès', 1, 14.99, 18, 'https://covers.openlibrary.org/b/id/8225631-L.jpg', 'Roman fondateur de la littérature moderne', '2026-01-29 23:22:21'),
(56, 'Le Vieil Homme et la Mer', 'Ernest Hemingway', 1, 9.99, 40, 'https://covers.openlibrary.org/b/id/8231998-L.jpg', 'Combat symbolique entre l’homme et la nature', '2026-01-29 23:22:21'),
(57, 'Fahrenheit 451', 'Ray Bradbury', 4, 13.99, 22, 'https://covers.openlibrary.org/b/id/8231854-L.jpg', 'Dystopie sur la censure et le savoir', '2026-01-29 23:22:21'),
(58, 'Le Meilleur des Mondes', 'Aldous Huxley', 4, 14.50, 25, 'https://covers.openlibrary.org/b/id/8773276-L.jpg', 'Société futuriste basée sur le conditionnement', '2026-01-29 23:22:21'),
(60, 'Animal Farm', 'George Orwell', 4, 8.99, 40, 'https://covers.openlibrary.org/b/id/8235111-L.jpg', 'Satire politique sous forme de fable', '2026-01-29 23:22:21'),
(61, 'Le Petit Nicolas', 'René Goscinny', 3, 8.50, 50, 'https://covers.openlibrary.org/b/id/8232025-L.jpg', 'Histoires amusantes de l’enfance', '2026-01-29 23:22:21'),
(62, 'Alice au Pays des Merveilles', 'Lewis Carroll', 3, 9.99, 45, 'https://covers.openlibrary.org/b/id/8228695-L.jpg', 'Conte fantastique et absurde', '2026-01-29 23:22:21'),
(63, 'Le Hobbit', 'J.R.R. Tolkien', 4, 14.99, 30, 'https://covers.openlibrary.org/b/id/6979861-L.jpg', 'Aventure fantastique en Terre du Milieu', '2026-01-29 23:22:21'),
(64, 'Chroniques de Narnia', 'C.S. Lewis', 4, 19.99, 20, 'https://covers.openlibrary.org/b/id/6979873-L.jpg', 'Saga fantastique pour jeunes lecteurs', '2026-01-29 23:22:21'),
(65, 'Sapiens', 'Yuval Noah Harari', 2, 18.99, 15, 'https://covers.openlibrary.org/b/id/8225265-L.jpg', 'Brève histoire de l’humanité', '2026-01-29 23:22:21'),
(66, 'L\'Art de la Guerre', 'Sun Tzu', 2, 9.50, 40, 'https://covers.openlibrary.org/b/id/8231992-L.jpg', 'Traité stratégique et philosophique', '2026-01-29 23:22:21'),
(67, 'Ainsi parlait Zarathoustra', 'Friedrich Nietzsche', 2, 13.99, 20, 'https://covers.openlibrary.org/b/id/8231991-L.jpg', 'Œuvre philosophique majeure', '2026-01-29 23:22:21'),
(68, 'Le Monde de Sophie', 'Jostein Gaarder', 2, 14.50, 25, 'https://covers.openlibrary.org/b/id/8232001-L.jpg', 'Introduction romancée à la philosophie', '2026-01-29 23:22:21'),
(69, 'Dracula', 'Bram Stoker', 1, 11.99, 28, 'https://covers.openlibrary.org/b/id/8231993-L.jpg', 'Roman gothique mythique', '2026-01-29 23:22:21'),
(70, 'Frankenstein', 'Mary Shelley', 1, 10.50, 30, 'https://covers.openlibrary.org/b/id/8231994-L.jpg', 'Naissance de la science-fiction moderne', '2026-01-29 23:22:21'),
(251, 'Le Nom de la Rose', 'Umberto Eco', 1, 14.90, 30, 'https://covers.openlibrary.org/b/id/8232145-L.jpg', 'Roman policier médiéval dans une abbaye bénédictine', '2026-01-30 16:00:00'),
(252, 'Cent ans de solitude', 'Gabriel García Márquez', 1, 16.50, 25, 'https://covers.openlibrary.org/b/id/8232146-L.jpg', 'Saga familiale dans le village fictif de Macondo', '2026-01-30 16:00:00'),
(253, 'Les Fleurs du Mal', 'Charles Baudelaire', 1, 11.99, 40, 'https://covers.openlibrary.org/b/id/8232147-L.jpg', 'Recueil poétique majeur du 19ème siècle', '2026-01-30 16:00:00'),
(254, 'Germinal', 'Émile Zola', 1, 13.75, 35, 'https://covers.openlibrary.org/b/id/8232148-L.jpg', 'Roman sur la condition des mineurs au 19ème siècle', '2026-01-30 16:00:00'),
(255, 'Le Procès', 'Franz Kafka', 1, 12.25, 28, 'https://covers.openlibrary.org/b/id/8232149-L.jpg', 'Roman absurde sur un homme poursuivi par la justice', '2026-01-30 16:00:00'),
(256, 'Guerre et Paix', 'Léon Tolstoï', 1, 19.99, 20, 'https://covers.openlibrary.org/b/id/8232150-L.jpg', 'Épopée historique sur la Russie napoléonienne', '2026-01-30 16:00:00'),
(257, 'Anna Karénine', 'Léon Tolstoï', 1, 15.50, 22, 'https://covers.openlibrary.org/b/id/8232151-L.jpg', 'Tragédie amoureuse dans la haute société russe', '2026-01-30 16:00:00'),
(258, 'Voyage au bout de la nuit', 'Louis-Ferdinand Céline', 1, 14.25, 18, 'https://covers.openlibrary.org/b/id/8232152-L.jpg', 'Roman nihiliste sur la Première Guerre mondiale', '2026-01-30 16:00:00'),
(259, 'L\'Éducation sentimentale', 'Gustave Flaubert', 1, 13.99, 30, 'https://covers.openlibrary.org/b/id/8232153-L.jpg', 'Roman d\'apprentissage dans le Paris du 19ème siècle', '2026-01-30 16:00:00'),
(260, 'Les Raisins de la colère', 'John Steinbeck', 1, 12.90, 25, 'https://covers.openlibrary.org/b/id/8232154-L.jpg', 'Roman sur la Grande Dépression aux États-Unis', '2026-01-30 16:00:00'),
(261, 'Le Château', 'Franz Kafka', 1, 11.75, 20, 'https://covers.openlibrary.org/b/id/8232155-L.jpg', 'Roman inachevé sur l\'absurdité bureaucratique', '2026-01-30 16:00:00'),
(262, 'La Condition humaine', 'André Malraux', 1, 13.50, 15, 'https://covers.openlibrary.org/b/id/8232156-L.jpg', 'Roman sur la révolution chinoise des années 1920', '2026-01-30 16:00:00'),
(263, 'Pourquoi j\'ai mangé mon père', 'Roy Lewis', 2, 10.99, 35, 'https://covers.openlibrary.org/b/id/8232157-L.jpg', 'Essai humoristique sur l\'évolution humaine', '2026-01-30 16:00:00'),
(264, 'Pensées', 'Blaise Pascal', 2, 9.50, 40, 'https://covers.openlibrary.org/b/id/8232158-L.jpg', 'Recueil de réflexions philosophiques et religieuses', '2026-01-30 16:00:00'),
(265, 'Le Mythe de Sisyphe', 'Albert Camus', 2, 11.25, 30, 'https://covers.openlibrary.org/b/id/8232159-L.jpg', 'Essai philosophique sur l\'absurde', '2026-01-30 16:00:00'),
(266, 'Être et Temps', 'Martin Heidegger', 2, 18.50, 12, 'https://covers.openlibrary.org/b/id/8232160-L.jpg', 'Ouvrage fondamental de la philosophie existentielle', '2026-01-30 16:00:00'),
(267, 'Critique de la raison pure', 'Emmanuel Kant', 2, 16.75, 15, 'https://covers.openlibrary.org/b/id/8232161-L.jpg', 'Traité philosophique sur les limites de la connaissance', '2026-01-30 16:00:00'),
(268, 'Le Prince', 'Nicolas Machiavel', 2, 8.99, 45, 'https://covers.openlibrary.org/b/id/8232162-L.jpg', 'Traité de science politique de la Renaissance', '2026-01-30 16:00:00'),
(269, 'La République', 'Platon', 2, 12.50, 30, 'https://covers.openlibrary.org/b/id/8232163-L.jpg', 'Dialogue philosophique sur la justice et l\'État idéal', '2026-01-30 16:00:00'),
(270, 'Le Banquet', 'Platon', 2, 10.75, 35, 'https://covers.openlibrary.org/b/id/8232164-L.jpg', 'Dialogue sur la nature de l\'amour', '2026-01-30 16:00:00'),
(271, 'Matilda', 'Roald Dahl', 3, 9.99, 50, 'https://covers.openlibrary.org/b/id/8232165-L.jpg', 'Histoire d\'une petite fille surdouée et de ses pouvoirs', '2026-01-30 16:00:00'),
(272, 'Charlie et la Chocolaterie', 'Roald Dahl', 3, 10.50, 45, 'https://covers.openlibrary.org/b/id/8232166-L.jpg', 'Aventure magique dans une usine de chocolat', '2026-01-30 16:00:00'),
(273, 'Le Lion', 'Joseph Kessel', 3, 11.25, 30, 'https://covers.openlibrary.org/b/id/8232167-L.jpg', 'Histoire d\'amitié entre une fillette et un lion', '2026-01-30 16:00:00'),
(274, 'Vendredi ou la Vie sauvage', 'Michel Tournier', 3, 9.75, 40, 'https://covers.openlibrary.org/b/id/8232168-L.jpg', 'Adaptation de Robinson Crusoé pour la jeunesse', '2026-01-30 16:00:00'),
(275, 'Le Petit Spirou', 'Tome et Janry', 3, 8.50, 55, 'https://covers.openlibrary.org/b/id/8232169-L.jpg', 'Aventures humoristiques du jeune Spirou', '2026-01-30 16:00:00'),
(276, 'Astérix le Gaulois', 'René Goscinny', 3, 9.25, 60, 'https://covers.openlibrary.org/b/id/8232170-L.jpg', 'Première aventure du célèbre Gaulois', '2026-01-30 16:00:00'),
(277, 'Tintin au Tibet', 'Hergé', 3, 12.99, 40, 'https://covers.openlibrary.org/b/id/8232171-L.jpg', 'Aventure de Tintin dans l\'Himalaya', '2026-01-30 16:00:00'),
(278, 'Le Seigneur des Anneaux : Les Deux Tours', 'J.R.R. Tolkien', 4, 18.50, 25, 'https://covers.openlibrary.org/b/id/8232172-L.jpg', 'Deuxième tome de la trilogie du Seigneur des Anneaux', '2026-01-30 16:00:00'),
(279, 'Le Seigneur des Anneaux : Le Retour du Roi', 'J.R.R. Tolkien', 4, 19.25, 22, 'https://covers.openlibrary.org/b/id/8232173-L.jpg', 'Troisième tome de la trilogie du Seigneur des Anneaux', '2026-01-30 16:00:00'),
(280, 'Les Robots', 'Isaac Asimov', 4, 14.75, 30, 'https://covers.openlibrary.org/b/id/8232174-L.jpg', 'Recueil de nouvelles sur les robots et les trois lois', '2026-01-30 16:00:00'),
(281, 'Chroniques martiennes', 'Ray Bradbury', 4, 13.99, 28, 'https://covers.openlibrary.org/b/id/8232175-L.jpg', 'Recueil de nouvelles sur la colonisation de Mars', '2026-01-30 16:00:00'),
(282, 'Ubik', 'Philip K. Dick', 4, 15.50, 20, 'https://covers.openlibrary.org/b/id/8232176-L.jpg', 'Roman de science-fiction psychologique', '2026-01-30 16:00:00'),
(283, 'Les Monades urbaines', 'Robert Silverberg', 4, 12.25, 18, 'https://covers.openlibrary.org/b/id/8232177-L.jpg', 'Roman dystopique sur une société ultra-urbanisée', '2026-01-30 16:00:00'),
(284, 'Neuromancien', 'William Gibson', 4, 16.99, 15, 'https://covers.openlibrary.org/b/id/8232178-L.jpg', 'Roman fondateur du genre cyberpunk', '2026-01-30 16:00:00'),
(285, 'Le Guetteur', 'Isaac Asimov', 4, 11.50, 25, 'https://covers.openlibrary.org/b/id/8232179-L.jpg', 'Roman policier de science-fiction', '2026-01-30 16:00:00'),
(286, 'Le Cycle de l\'Épée de Vérité', 'Terry Goodkind', 4, 17.75, 20, 'https://covers.openlibrary.org/b/id/8232180-L.jpg', 'Premier tome d\'une saga fantasy épique', '2026-01-30 16:00:00'),
(287, 'L\'Assassin royal', 'Robin Hobb', 4, 14.99, 22, 'https://covers.openlibrary.org/b/id/8232181-L.jpg', 'Premier tome d\'une trilogie fantasy', '2026-01-30 16:00:00'),
(288, 'Le Trône de Fer', 'George R.R. Martin', 4, 18.25, 18, 'https://covers.openlibrary.org/b/id/8232182-L.jpg', 'Premier tome de la saga du Trône de Fer', '2026-01-30 16:00:00'),
(289, 'La Horde du Contrevent', 'Alain Damasio', 4, 19.99, 15, 'https://covers.openlibrary.org/b/id/8232183-L.jpg', 'Roman d\'aventure dans un monde parcouru par le vent', '2026-01-30 16:00:00'),
(290, 'Les Thanatonautes', 'Bernard Werber', 4, 13.50, 30, 'https://covers.openlibrary.org/b/id/8232184-L.jpg', 'Roman d\'exploration scientifique de la mort', '2026-01-30 16:00:00'),
(291, 'La Première Guerre mondiale', 'John Keegan', 5, 21.50, 12, 'https://covers.openlibrary.org/b/id/8232185-L.jpg', 'Histoire complète de la Grande Guerre', '2026-01-30 16:00:00'),
(292, 'La Seconde Guerre mondiale', 'Antony Beevor', 5, 24.99, 10, 'https://covers.openlibrary.org/b/id/8232186-L.jpg', 'Analyse approfondie du conflit mondial', '2026-01-30 16:00:00'),
(293, 'Les Mémoires de guerre', 'Charles de Gaulle', 5, 19.75, 15, 'https://covers.openlibrary.org/b/id/8232187-L.jpg', 'Mémoires du général de Gaulle sur la Seconde Guerre mondiale', '2026-01-30 16:00:00'),
(294, 'L\'Égypte ancienne', 'Toby Wilkinson', 5, 22.50, 8, 'https://covers.openlibrary.org/b/id/8232188-L.jpg', 'Histoire complète de l\'Égypte des pharaons', '2026-01-30 16:00:00'),
(295, 'SPQR : Histoire de l\'ancienne Rome', 'Mary Beard', 5, 20.99, 12, 'https://covers.openlibrary.org/b/id/8232189-L.jpg', 'Nouvelle histoire de la Rome antique', '2026-01-30 16:00:00'),
(296, 'Les Croisades vues par les Arabes', 'Amin Maalouf', 5, 16.75, 20, 'https://covers.openlibrary.org/b/id/8232190-L.jpg', 'Histoire des croisades du point de vue arabe', '2026-01-30 16:00:00'),
(297, 'Histoire de la folie à l\'âge classique', 'Michel Foucault', 5, 18.25, 15, 'https://covers.openlibrary.org/b/id/8232191-L.jpg', 'Étude historique de la conception de la folie', '2026-01-30 16:00:00'),
(298, 'La Méditerranée et le Monde méditerranéen', 'Fernand Braudel', 5, 23.50, 10, 'https://covers.openlibrary.org/b/id/8232192-L.jpg', 'Grande œuvre d\'histoire totale de la Méditerranée', '2026-01-30 16:00:00'),
(299, 'Les Rois maudits', 'Maurice Druon', 5, 15.99, 25, 'https://covers.openlibrary.org/b/id/8232193-L.jpg', 'Roman historique sur la monarchie française', '2026-01-30 16:00:00'),
(300, 'Le Nom du vent', 'Patrick Rothfuss', 4, 17.50, 20, 'https://covers.openlibrary.org/b/id/8232194-L.jpg', 'Premier tome de la Chronique du Tueur de Roi', '2026-01-30 16:00:00'),
(301, 'La Peau de chagrin', 'Honoré de Balzac', 1, 12.25, 30, 'https://covers.openlibrary.org/b/id/8232195-L.jpg', 'Roman philosophique sur la quête du bonheur', '2026-01-30 16:00:00'),
(302, 'Les Contemplations', 'Victor Hugo', 1, 11.99, 35, 'https://covers.openlibrary.org/b/id/8232196-L.jpg', 'Recueil poétique majeur de Victor Hugo', '2026-01-30 16:00:00'),
(303, 'Les Misérables : Cosette', 'Victor Hugo', 1, 14.50, 20, 'https://covers.openlibrary.org/b/id/8232197-L.jpg', 'Deuxième partie des Misérables', '2026-01-30 16:00:00'),
(304, 'Le Rouge et le Noir', 'Stendhal', 1, 13.25, 25, 'https://covers.openlibrary.org/b/id/8232198-L.jpg', 'Roman d\'apprentissage dans la France du 19ème siècle', '2026-01-30 16:00:00'),
(305, 'La Chartreuse de Parme', 'Stendhal', 1, 14.75, 22, 'https://covers.openlibrary.org/b/id/8232199-L.jpg', 'Roman sur l\'Italie napoléonienne', '2026-01-30 16:00:00'),
(306, 'Les Hauts de Hurlevent', 'Emily Brontë', 1, 12.99, 28, 'https://covers.openlibrary.org/b/id/8232200-L.jpg', 'Roman gothique sur la passion destructrice', '2026-01-30 16:00:00'),
(307, 'Jane Eyre', 'Charlotte Brontë', 1, 13.50, 30, 'https://covers.openlibrary.org/b/id/8232201-L.jpg', 'Roman d\'apprentissage d\'une jeune gouvernante', '2026-01-30 16:00:00'),
(308, 'Moby Dick', 'Herman Melville', 1, 15.25, 18, 'https://covers.openlibrary.org/b/id/8232202-L.jpg', 'Épopée maritime sur la chasse à la baleine blanche', '2026-01-30 16:00:00'),
(309, 'Les Aventures de Huckleberry Finn', 'Mark Twain', 1, 11.50, 35, 'https://covers.openlibrary.org/b/id/8232203-L.jpg', 'Roman d\'aventures sur le Mississippi', '2026-01-30 16:00:00'),
(310, 'La Peste écarlate', 'Jack London', 1, 9.99, 35, 'https://covers.openlibrary.org/b/id/8232205-L.jpg', 'Roman post-apocalyptique sur une épidémie mondiale', '2026-01-30 17:00:00'),
(311, 'L\'Île au trésor', 'Robert Louis Stevenson', 1, 11.50, 40, 'https://covers.openlibrary.org/b/id/8232206-L.jpg', 'Aventure classique de pirates et de trésors cachés', '2026-01-30 17:00:00'),
(312, 'Le Portrait de Dorian Gray', 'Oscar Wilde', 1, 10.75, 30, 'https://covers.openlibrary.org/b/id/8232207-L.jpg', 'Roman philosophique sur la beauté et la corruption', '2026-01-30 17:00:00'),
(313, 'Les Trois Mousquetaires', 'Alexandre Dumas', 1, 14.25, 25, 'https://covers.openlibrary.org/b/id/8232208-L.jpg', 'Aventure historique dans la France du XVIIe siècle', '2026-01-30 17:00:00'),
(314, 'Vingt mille lieues sous les mers', 'Jules Verne', 1, 13.50, 28, 'https://covers.openlibrary.org/b/id/8232209-L.jpg', 'Voyage extraordinaire à bord du Nautilus', '2026-01-30 17:00:00'),
(315, 'Le Tour du monde en quatre-vingts jours', 'Jules Verne', 1, 12.99, 32, 'https://covers.openlibrary.org/b/id/8232210-L.jpg', 'Course contre la montre autour du globe', '2026-01-30 17:00:00'),
(316, 'Les Frères Karamazov', 'Fiodor Dostoïevski', 1, 17.50, 18, 'https://covers.openlibrary.org/b/id/8232211-L.jpg', 'Drame familial et philosophique russe', '2026-01-30 17:00:00'),
(317, 'L\'Idiot', 'Fiodor Dostoïevski', 1, 15.75, 20, 'https://covers.openlibrary.org/b/id/8232212-L.jpg', 'Portrait d\'un homme naïvement bon dans une société corrompue', '2026-01-30 17:00:00'),
(318, 'Bel-Ami', 'Guy de Maupassant', 1, 11.25, 30, 'https://covers.openlibrary.org/b/id/8232213-L.jpg', 'Ascension sociale d\'un homme ambitieux à Paris', '2026-01-30 17:00:00'),
(319, 'Une vie', 'Guy de Maupassant', 1, 10.99, 28, 'https://covers.openlibrary.org/b/id/8232214-L.jpg', 'Destin tragique d\'une femme dans la Normandie du XIXe siècle', '2026-01-30 17:00:00'),
(320, 'Le Père Goriot', 'Honoré de Balzac', 1, 12.50, 25, 'https://covers.openlibrary.org/b/id/8232215-L.jpg', 'Drame paternel dans la Comédie Humaine', '2026-01-30 17:00:00'),
(321, 'Eugénie Grandet', 'Honoré de Balzac', 1, 11.75, 30, 'https://covers.openlibrary.org/b/id/8232216-L.jpg', 'Histoire d\'une jeune femme sacrifiée à l\'avarice paternelle', '2026-01-30 17:00:00'),
(322, 'Les Liaisons dangereuses', 'Pierre Choderlos de Laclos', 1, 13.25, 22, 'https://covers.openlibrary.org/b/id/8232217-L.jpg', 'Roman épistolaire sur la séduction et la manipulation', '2026-01-30 17:00:00'),
(323, 'Lolita', 'Vladimir Nabokov', 1, 14.99, 20, 'https://covers.openlibrary.org/b/id/8232218-L.jpg', 'Roman controversé sur une obsession amoureuse', '2026-01-30 17:00:00'),
(324, 'Mrs Dalloway', 'Virginia Woolf', 1, 12.25, 25, 'https://covers.openlibrary.org/b/id/8232219-L.jpg', 'Roman psychologique sur une journée dans la vie d\'une femme', '2026-01-30 17:00:00'),
(325, 'Orlando', 'Virginia Woolf', 1, 13.50, 20, 'https://covers.openlibrary.org/b/id/8232220-L.jpg', 'Biographie fantaisiste traversant les siècles et les genres', '2026-01-30 17:00:00'),
(326, 'Le Vieil Homme et l\'Enfant', 'Claude Berri', 1, 9.75, 35, 'https://covers.openlibrary.org/b/id/8232221-L.jpg', 'Récit autobiographique sur l\'occupation allemande', '2026-01-30 17:00:00'),
(327, 'Le Silence de la mer', 'Vercors', 1, 8.99, 40, 'https://covers.openlibrary.org/b/id/8232222-L.jpg', 'Nouvelle sur la Résistance pendant la Seconde Guerre mondiale', '2026-01-30 17:00:00'),
(328, 'L\'Écume des jours', 'Boris Vian', 1, 12.99, 30, 'https://covers.openlibrary.org/b/id/8232223-L.jpg', 'Roman d\'amour surréaliste et poétique', '2026-01-30 17:00:00'),
(329, 'La Nausée', 'Jean-Paul Sartre', 1, 11.50, 28, 'https://covers.openlibrary.org/b/id/8232224-L.jpg', 'Roman existentialiste sur le sens de l\'existence', '2026-01-30 17:00:00'),
(330, 'La Conscience de Zeno', 'Italo Svevo', 1, 13.25, 22, 'https://covers.openlibrary.org/b/id/8232225-L.jpg', 'Roman psychanalytique sur un homme et ses névroses', '2026-01-30 17:00:00'),
(331, 'Le Bruit et la Fureur', 'William Faulkner', 1, 14.50, 18, 'https://covers.openlibrary.org/b/id/8232226-L.jpg', 'Roman expérimental sur le déclin d\'une famille sudiste', '2026-01-30 17:00:00'),
(332, 'Tandis que j\'agonise', 'William Faulkner', 1, 12.75, 20, 'https://covers.openlibrary.org/b/id/8232227-L.jpg', 'Récit polyphonique d\'un voyage funèbre', '2026-01-30 17:00:00'),
(333, 'Sur la route', 'Jack Kerouac', 1, 13.99, 25, 'https://covers.openlibrary.org/b/id/8232228-L.jpg', 'Roman de la Beat Generation sur la quête de liberté', '2026-01-30 17:00:00'),
(334, 'Les Cloches de Bâle', 'Louis Aragon', 1, 12.50, 20, 'https://covers.openlibrary.org/b/id/8232229-L.jpg', 'Roman sur les débuts du mouvement ouvrier', '2026-01-30 17:00:00'),
(335, 'Le Rivage des Syrtes', 'Julien Gracq', 1, 14.25, 18, 'https://covers.openlibrary.org/b/id/8232230-L.jpg', 'Roman onirique sur l\'attente et la guerre', '2026-01-30 17:00:00'),
(336, 'Les Bienveillantes', 'Jonathan Littell', 1, 22.50, 15, 'https://covers.openlibrary.org/b/id/8232231-L.jpg', 'Roman historique sur un officier SS durant la Shoah', '2026-01-30 17:00:00'),
(337, 'La Carte et le Territoire', 'Michel Houellebecq', 1, 16.99, 20, 'https://covers.openlibrary.org/b/id/8232232-L.jpg', 'Roman satirique sur l\'art et la société contemporaine', '2026-01-30 17:00:00'),
(338, 'Soumission', 'Michel Houellebecq', 1, 15.50, 22, 'https://covers.openlibrary.org/b/id/8232233-L.jpg', 'Dystopie politique sur la France du futur', '2026-01-30 17:00:00'),
(339, 'Les Particules élémentaires', 'Michel Houellebecq', 1, 14.75, 25, 'https://covers.openlibrary.org/b/id/8232234-L.jpg', 'Roman sur la solitude dans la société moderne', '2026-01-30 17:00:00'),
(340, 'La Possibilité d\'une île', 'Michel Houellebecq', 1, 15.25, 20, 'https://covers.openlibrary.org/b/id/8232235-L.jpg', 'Roman de science-fiction philosophique', '2026-01-30 17:00:00'),
(341, 'La Théorie du tube de dentifrice', 'Frédéric Beigbeder', 2, 13.99, 25, 'https://covers.openlibrary.org/b/id/8232236-L.jpg', 'Essai sur la société de consommation', '2026-01-30 17:00:00'),
(342, 'Le Premier Principe', 'Michel Serres', 2, 16.50, 18, 'https://covers.openlibrary.org/b/id/8232237-L.jpg', 'Essai philosophique sur les fondements de la connaissance', '2026-01-30 17:00:00'),
(343, 'Petite Poucette', 'Michel Serres', 2, 9.99, 35, 'https://covers.openlibrary.org/b/id/8232238-L.jpg', 'Essai sur les nouvelles générations à l\'ère numérique', '2026-01-30 17:00:00'),
(344, 'Le Phénomène humain', 'Pierre Teilhard de Chardin', 2, 14.75, 20, 'https://covers.openlibrary.org/b/id/8232239-L.jpg', 'Essai sur l\'évolution et la place de l\'homme dans l\'univers', '2026-01-30 17:00:00'),
(345, 'Le Hasard et la Nécessité', 'Jacques Monod', 2, 13.50, 22, 'https://covers.openlibrary.org/b/id/8232240-L.jpg', 'Essai sur la biologie moléculaire et la philosophie', '2026-01-30 17:00:00'),
(346, 'L\'Homme neuronal', 'Jean-Pierre Changeux', 2, 15.25, 18, 'https://covers.openlibrary.org/b/id/8232241-L.jpg', 'Essai sur les neurosciences et la conscience', '2026-01-30 17:00:00'),
(347, 'Le Goût de l\'avenir', 'Joël de Rosnay', 2, 12.99, 25, 'https://covers.openlibrary.org/b/id/8232242-L.jpg', 'Essai prospectif sur les technologies du futur', '2026-01-30 17:00:00'),
(348, 'Les Structures anthropologiques de l\'imaginaire', 'Gilbert Durand', 2, 18.50, 15, 'https://covers.openlibrary.org/b/id/8232243-L.jpg', 'Essai sur l\'anthropologie et l\'imaginaire humain', '2026-01-30 17:00:00'),
(349, 'Le Complexe de l\'autruche', 'Gustave Le Bon', 2, 11.75, 30, 'https://covers.openlibrary.org/b/id/8232244-L.jpg', 'Essai de psychologie sociale', '2026-01-30 17:00:00'),
(350, 'Le Moi et le Ça', 'Sigmund Freud', 2, 12.50, 25, 'https://covers.openlibrary.org/b/id/8232245-L.jpg', 'Ouvrage fondateur de la psychanalyse', '2026-01-30 17:00:00'),
(351, 'Moi, Christiane F., 13 ans, droguée, prostituée', 'Christiane F.', 2, 14.99, 20, 'https://covers.openlibrary.org/b/id/8232246-L.jpg', 'Témoignage autobiographique sur la toxicomanie', '2026-01-30 17:00:00'),
(352, 'Le Monde selon Garp', 'John Irving', 2, 15.50, 22, 'https://covers.openlibrary.org/b/id/8232247-L.jpg', 'Roman de formation et réflexion sur l\'écriture', '2026-01-30 17:00:00'),
(353, 'Les Mots', 'Jean-Paul Sartre', 2, 11.25, 30, 'https://covers.openlibrary.org/b/id/8232248-L.jpg', 'Autobiographie intellectuelle du philosophe', '2026-01-30 17:00:00'),
(354, 'Mémoires d\'Hadrien', 'Marguerite Yourcenar', 2, 13.75, 25, 'https://covers.openlibrary.org/b/id/8232249-L.jpg', 'Autobiographie fictive de l\'empereur romain', '2026-01-30 17:00:00'),
(355, 'L\'Œuvre au noir', 'Marguerite Yourcenar', 2, 14.50, 22, 'https://covers.openlibrary.org/b/id/8232250-L.jpg', 'Roman historique sur un alchimiste à la Renaissance', '2026-01-30 17:00:00'),
(356, 'Le Petit Chose', 'Alphonse Daudet', 3, 9.50, 40, 'https://covers.openlibrary.org/b/id/8232251-L.jpg', 'Roman autobiographique sur l\'enfance et l\'adolescence', '2026-01-30 17:00:00'),
(357, 'Sans famille', 'Hector Malot', 3, 11.25, 35, 'https://covers.openlibrary.org/b/id/8232252-L.jpg', 'Roman d\'aventures d\'un enfant abandonné', '2026-01-30 17:00:00'),
(358, 'Les Malheurs de Sophie', 'Comtesse de Ségur', 3, 8.99, 45, 'https://covers.openlibrary.org/b/id/8232253-L.jpg', 'Histoires d\'une petite fille espiègle au XIXe siècle', '2026-01-30 17:00:00'),
(359, 'Les Petites Filles modèles', 'Comtesse de Ségur', 3, 9.25, 40, 'https://covers.openlibrary.org/b/id/8232254-L.jpg', 'Roman pour enfants sur l\'éducation et l\'amitié', '2026-01-30 17:00:00'),
(360, 'Le Bonheur des tristes', 'Marcel Pagnol', 3, 10.50, 35, 'https://covers.openlibrary.org/b/id/8232255-L.jpg', 'Récits d\'enfance provençale', '2026-01-30 17:00:00'),
(361, 'La Gloire de mon père', 'Marcel Pagnol', 3, 11.75, 30, 'https://covers.openlibrary.org/b/id/8232256-L.jpg', 'Premier tome des souvenirs d\'enfance', '2026-01-30 17:00:00'),
(362, 'Le Château de ma mère', 'Marcel Pagnol', 3, 11.25, 32, 'https://covers.openlibrary.org/b/id/8232257-L.jpg', 'Suite des souvenirs d\'enfance provençaux', '2026-01-30 17:00:00'),
(363, 'Le Temps des secrets', 'Marcel Pagnol', 3, 11.50, 28, 'https://covers.openlibrary.org/b/id/8232258-L.jpg', 'Troisième tome des souvenirs d\'enfance', '2026-01-30 17:00:00'),
(364, 'Le Temps des amours', 'Marcel Pagnol', 3, 12.25, 25, 'https://covers.openlibrary.org/b/id/8232259-L.jpg', 'Dernier tome des souvenirs d\'enfance et d\'adolescence', '2026-01-30 17:00:00'),
(365, 'Les Contes du chat perché', 'Marcel Aymé', 3, 13.99, 30, 'https://covers.openlibrary.org/b/id/8232260-L.jpg', 'Contes fantastiques pour enfants', '2026-01-30 17:00:00'),
(366, 'Le Passe-muraille', 'Marcel Aymé', 3, 10.75, 35, 'https://covers.openlibrary.org/b/id/8232261-L.jpg', 'Nouvelles fantastiques et humoristiques', '2026-01-30 17:00:00'),
(367, 'Vipère au poing', 'Hervé Bazin', 3, 12.50, 28, 'https://covers.openlibrary.org/b/id/8232262-L.jpg', 'Roman autobiographique sur une enfance malheureuse', '2026-01-30 17:00:00'),
(368, 'Le Grand Meaulnes', 'Alain-Fournier', 3, 11.25, 30, 'https://covers.openlibrary.org/b/id/8232263-L.jpg', 'Roman d\'aventures et d\'amour adolescent', '2026-01-30 17:00:00'),
(369, 'Les Fables de La Fontaine', 'Jean de La Fontaine', 3, 10.99, 40, 'https://covers.openlibrary.org/b/id/8232264-L.jpg', 'Recueil de fables animales et morales', '2026-01-30 17:00:00'),
(370, 'Contes de Perrault', 'Charles Perrault', 3, 9.75, 45, 'https://covers.openlibrary.org/b/id/8232265-L.jpg', 'Contes classiques : Cendrillon, Peau d\'Âne, etc.', '2026-01-30 17:00:00'),
(371, 'Les Contes de Grimm', 'Frères Grimm', 3, 11.50, 38, 'https://covers.openlibrary.org/b/id/8232266-L.jpg', 'Contes populaires allemands traditionnels', '2026-01-30 17:00:00'),
(372, 'Les Contes d\'Andersen', 'Hans Christian Andersen', 3, 12.25, 35, 'https://covers.openlibrary.org/b/id/8232267-L.jpg', 'Contes merveilleux du célèbre auteur danois', '2026-01-30 17:00:00'),
(373, 'Les Aventures de Tom Sawyer', 'Mark Twain', 3, 10.50, 40, 'https://covers.openlibrary.org/b/id/8232268-L.jpg', 'Aventures d\'un jeune garçon sur le Mississippi', '2026-01-30 17:00:00'),
(374, 'Les Aventures d\'Oliver Twist', 'Charles Dickens', 3, 11.75, 32, 'https://covers.openlibrary.org/b/id/8232269-L.jpg', 'Histoire d\'un orphelin dans l\'Angleterre victorienne', '2026-01-30 17:00:00'),
(375, 'David Copperfield', 'Charles Dickens', 3, 14.50, 25, 'https://covers.openlibrary.org/b/id/8232270-L.jpg', 'Roman d\'apprentissage semi-autobiographique', '2026-01-30 17:00:00'),
(376, 'Les Quatre Filles du docteur March', 'Louisa May Alcott', 3, 12.99, 30, 'https://covers.openlibrary.org/b/id/8232271-L.jpg', 'Histoire de quatre sœurs pendant la Guerre de Sécession', '2026-01-30 17:00:00'),
(377, 'Le Monde de Narnia : Le Lion, la Sorcière blanche et l\'Armoire magique', 'C.S. Lewis', 3, 13.50, 28, 'https://covers.openlibrary.org/b/id/8232272-L.jpg', 'Premier tome des Chroniques de Narnia', '2026-01-30 17:00:00'),
(378, 'Le Monde de Narnia : Le Prince Caspian', 'C.S. Lewis', 3, 13.25, 26, 'https://covers.openlibrary.org/b/id/8232273-L.jpg', 'Deuxième tome des Chroniques de Narnia', '2026-01-30 17:00:00'),
(379, 'Le Monde de Narnia : L\'Odyssée du Passeur d\'Aurore', 'C.S. Lewis', 3, 13.75, 24, 'https://covers.openlibrary.org/b/id/8232274-L.jpg', 'Troisième tome des Chroniques de Narnia', '2026-01-30 17:00:00'),
(380, 'La Chute', 'Albert Camus', 1, 11.25, 35, 'https://covers.openlibrary.org/b/id/8232275-L.jpg', 'Monologue d\'un ancien avocat parisien en exil à Amsterdam', '2026-01-31 08:00:00'),
(381, 'Les Justes', 'Albert Camus', 1, 10.50, 30, 'https://covers.openlibrary.org/b/id/8232276-L.jpg', 'Pièce de théâtre sur des révolutionnaires russes en 1905', '2026-01-31 08:00:00'),
(382, 'La Mort heureuse', 'Albert Camus', 1, 12.75, 25, 'https://covers.openlibrary.org/b/id/8232277-L.jpg', 'Premier roman inachevé d\'Albert Camus', '2026-01-31 08:00:00'),
(383, 'Le Premier Homme', 'Albert Camus', 1, 13.50, 22, 'https://covers.openlibrary.org/b/id/8232278-L.jpg', 'Roman autobiographique inachevé publié à titre posthume', '2026-01-31 08:00:00'),
(384, 'L\'Envers et l\'Endroit', 'Albert Camus', 1, 9.99, 40, 'https://covers.openlibrary.org/b/id/8232279-L.jpg', 'Premier recueil d\'essais et de nouvelles', '2026-01-31 08:00:00'),
(385, 'Noces', 'Albert Camus', 1, 10.25, 38, 'https://covers.openlibrary.org/b/id/8232280-L.jpg', 'Recueil d\'essais lyriques sur l\'Algérie', '2026-01-31 08:00:00'),
(386, 'L\'Été', 'Albert Camus', 1, 11.00, 32, 'https://covers.openlibrary.org/b/id/8232281-L.jpg', 'Recueil d\'essais écrits entre 1939 et 1953', '2026-01-31 08:00:00'),
(387, 'La Pierre qui pousse', 'Albert Camus', 1, 8.99, 45, 'https://covers.openlibrary.org/b/id/8232282-L.jpg', 'Recueil de nouvelles sur l\'Algérie', '2026-01-31 08:00:00'),
(388, 'Le Malentendu', 'Albert Camus', 1, 9.50, 42, 'https://covers.openlibrary.org/b/id/8232283-L.jpg', 'Pièce de théâtre sur l\'absurdité de l\'existence', '2026-01-31 08:00:00'),
(389, 'Caligula', 'Albert Camus', 1, 10.75, 36, 'https://covers.openlibrary.org/b/id/8232284-L.jpg', 'Pièce de théâtre inspirée de l\'empereur romain', '2026-01-31 08:00:00'),
(390, 'État de siège', 'Albert Camus', 1, 11.50, 28, 'https://covers.openlibrary.org/b/id/8232285-L.jpg', 'Pièce allégorique sur la tyrannie', '2026-01-31 08:00:00'),
(391, 'Les Possédés', 'Albert Camus', 1, 15.25, 20, 'https://covers.openlibrary.org/b/id/8232286-L.jpg', 'Adaptation théâtrale du roman de Dostoïevski', '2026-01-31 08:00:00'),
(392, 'Le Minotaure ou la Halte d\'Oran', 'Albert Camus', 1, 8.50, 48, 'https://covers.openlibrary.org/b/id/8232287-L.jpg', 'Essai sur la ville d\'Oran', '2026-01-31 08:00:00'),
(393, 'L\'Exil et le Royaume', 'Albert Camus', 1, 12.25, 30, 'https://covers.openlibrary.org/b/id/8232288-L.jpg', 'Recueil de six nouvelles', '2026-01-31 08:00:00'),
(394, 'Discours de Suède', 'Albert Camus', 1, 7.99, 50, 'https://covers.openlibrary.org/b/id/8232289-L.jpg', 'Discours prononcé lors de la remise du Prix Nobel', '2026-01-31 08:00:00'),
(395, 'Lettres à un ami allemand', 'Albert Camus', 1, 9.25, 44, 'https://covers.openlibrary.org/b/id/8232290-L.jpg', 'Quatre lettres écrites pendant l\'Occupation', '2026-01-31 08:00:00'),
(396, 'Les Chemins de la liberté', 'Jean-Paul Sartre', 1, 16.50, 18, 'https://covers.openlibrary.org/b/id/8232291-L.jpg', 'Trilogie romanesque inachevée', '2026-01-31 08:00:00'),
(397, 'L\'Âge de raison', 'Jean-Paul Sartre', 1, 13.75, 25, 'https://covers.openlibrary.org/b/id/8232292-L.jpg', 'Premier tome des Chemins de la liberté', '2026-01-31 08:00:00'),
(398, 'Le Sursis', 'Jean-Paul Sartre', 1, 14.25, 22, 'https://covers.openlibrary.org/b/id/8232293-L.jpg', 'Deuxième tome des Chemins de la liberté', '2026-01-31 08:00:00'),
(399, 'La Mort dans l\'âme', 'Jean-Paul Sartre', 1, 13.99, 24, 'https://covers.openlibrary.org/b/id/8232294-L.jpg', 'Troisième tome des Chemins de la liberté', '2026-01-31 08:00:00'),
(400, 'La Putain respectueuse', 'Jean-Paul Sartre', 1, 8.75, 46, 'https://covers.openlibrary.org/b/id/8232295-L.jpg', 'Pièce de théâtre sur le racisme aux États-Unis', '2026-01-31 08:00:00'),
(401, 'Les Mains sales', 'Jean-Paul Sartre', 1, 10.50, 38, 'https://covers.openlibrary.org/b/id/8232296-L.jpg', 'Pièce politique sur l\'engagement révolutionnaire', '2026-01-31 08:00:00'),
(402, 'Huis clos', 'Jean-Paul Sartre', 1, 9.99, 42, 'https://covers.openlibrary.org/b/id/8232297-L.jpg', 'Pièce existentialiste célèbre : \"L\'enfer, c\'est les autres\"', '2026-01-31 08:00:00'),
(403, 'Les Mouches', 'Jean-Paul Sartre', 1, 10.25, 40, 'https://covers.openlibrary.org/b/id/8232298-L.jpg', 'Adaptation moderne du mythe d\'Oreste', '2026-01-31 08:00:00'),
(404, 'Le Diable et le Bon Dieu', 'Jean-Paul Sartre', 1, 12.50, 28, 'https://covers.openlibrary.org/b/id/8232299-L.jpg', 'Pièce historique sur l\'Allemagne du XVIe siècle', '2026-01-31 08:00:00'),
(405, 'Les Séquestrés d\'Altona', 'Jean-Paul Sartre', 1, 11.75, 32, 'https://covers.openlibrary.org/b/id/8232300-L.jpg', 'Pièce sur la culpabilité et la mémoire de la guerre', '2026-01-31 08:00:00'),
(406, 'Baudelaire', 'Jean-Paul Sartre', 1, 13.25, 26, 'https://covers.openlibrary.org/b/id/8232301-L.jpg', 'Essai biographique sur Charles Baudelaire', '2026-01-31 08:00:00'),
(407, 'Saint Genet, comédien et martyr', 'Jean-Paul Sartre', 1, 15.99, 20, 'https://covers.openlibrary.org/b/id/8232302-L.jpg', 'Biographie existentielle de Jean Genet', '2026-01-31 08:00:00'),
(408, 'L\'Idiot de la famille', 'Jean-Paul Sartre', 1, 18.50, 15, 'https://covers.openlibrary.org/b/id/8232303-L.jpg', 'Étude monumentale sur Flaubert', '2026-01-31 08:00:00'),
(409, 'Qu\'est-ce que la littérature?', 'Jean-Paul Sartre', 1, 12.99, 30, 'https://covers.openlibrary.org/b/id/8232304-L.jpg', 'Essai sur l\'engagement de l\'écrivain', '2026-01-31 08:00:00'),
(410, 'Situations I', 'Jean-Paul Sartre', 1, 14.50, 24, 'https://covers.openlibrary.org/b/id/8232305-L.jpg', 'Recueil d\'essais critiques', '2026-01-31 08:00:00'),
(411, 'Situations II', 'Jean-Paul Sartre', 1, 14.75, 22, 'https://covers.openlibrary.org/b/id/8232306-L.jpg', 'Second recueil d\'essais critiques', '2026-01-31 08:00:00'),
(412, 'Situations III', 'Jean-Paul Sartre', 1, 15.25, 20, 'https://covers.openlibrary.org/b/id/8232307-L.jpg', 'Troisième recueil d\'essais critiques', '2026-01-31 08:00:00'),
(413, 'Situations IV', 'Jean-Paul Sartre', 1, 15.50, 18, 'https://covers.openlibrary.org/b/id/8232308-L.jpg', 'Recueil d\'essais sur la politique', '2026-01-31 08:00:00'),
(414, 'Situations V', 'Jean-Paul Sartre', 1, 15.75, 16, 'https://covers.openlibrary.org/b/id/8232309-L.jpg', 'Recueil d\'essais sur la littérature', '2026-01-31 08:00:00'),
(415, 'Situations VI', 'Jean-Paul Sartre', 1, 16.00, 15, 'https://covers.openlibrary.org/b/id/8232310-L.jpg', 'Recueil d\'essais sur la philosophie', '2026-01-31 08:00:00'),
(416, 'Situations VII', 'Jean-Paul Sartre', 1, 16.25, 14, 'https://covers.openlibrary.org/b/id/8232311-L.jpg', 'Recueil d\'essais sur la critique littéraire', '2026-01-31 08:00:00'),
(417, 'Situations VIII', 'Jean-Paul Sartre', 1, 16.50, 12, 'https://covers.openlibrary.org/b/id/8232312-L.jpg', 'Recueil d\'essais divers', '2026-01-31 08:00:00'),
(418, 'Situations IX', 'Jean-Paul Sartre', 1, 16.75, 10, 'https://covers.openlibrary.org/b/id/8232313-L.jpg', 'Dernier recueil d\'essais', '2026-01-31 08:00:00'),
(419, 'Réflexions sur la question juive', 'Jean-Paul Sartre', 1, 11.25, 34, 'https://covers.openlibrary.org/b/id/8232314-L.jpg', 'Essai sur l\'antisémitisme', '2026-01-31 08:00:00'),
(420, 'L\'Existentialisme est un humanisme', 'Jean-Paul Sartre', 1, 10.50, 40, 'https://covers.openlibrary.org/b/id/8232315-L.jpg', 'Conférence populaire sur l\'existentialisme', '2026-01-31 08:00:00'),
(421, 'L\'Imaginaire', 'Jean-Paul Sartre', 1, 13.99, 26, 'https://covers.openlibrary.org/b/id/8232316-L.jpg', 'Essai phénoménologique sur l\'imagination', '2026-01-31 08:00:00'),
(422, 'L\'Être et le Néant', 'Jean-Paul Sartre', 1, 19.99, 12, 'https://covers.openlibrary.org/b/id/8232317-L.jpg', 'Œuvre majeure de la philosophie existentielle', '2026-01-31 08:00:00'),
(423, 'Critique de la raison dialectique', 'Jean-Paul Sartre', 1, 21.50, 10, 'https://covers.openlibrary.org/b/id/8232318-L.jpg', 'Tentative de synthèse entre existentialisme et marxisme', '2026-01-31 08:00:00'),
(424, 'Carnets de la drôle de guerre', 'Jean-Paul Sartre', 1, 14.25, 22, 'https://covers.openlibrary.org/b/id/8232319-L.jpg', 'Journal tenu pendant la mobilisation de 1939-1940', '2026-01-31 08:00:00'),
(425, 'Les Jeux sont faits', 'Jean-Paul Sartre', 1, 9.75, 44, 'https://covers.openlibrary.org/b/id/8232320-L.jpg', 'Scénario de film métaphysique', '2026-01-31 08:00:00'),
(426, 'L\'Engrenage', 'Jean-Paul Sartre', 1, 10.25, 38, 'https://covers.openlibrary.org/b/id/8232321-L.jpg', 'Pièce sur les mécanismes du pouvoir', '2026-01-31 08:00:00'),
(427, 'Kean', 'Jean-Paul Sartre', 1, 11.50, 30, 'https://covers.openlibrary.org/b/id/8232322-L.jpg', 'Adaptation de la pièce d\'Alexandre Dumas', '2026-01-31 08:00:00'),
(428, 'Nekrassov', 'Jean-Paul Sartre', 1, 10.99, 36, 'https://covers.openlibrary.org/b/id/8232323-L.jpg', 'Comédie satirique sur le journalisme', '2026-01-31 08:00:00'),
(429, 'Bariona', 'Jean-Paul Sartre', 1, 8.50, 48, 'https://covers.openlibrary.org/b/id/8232324-L.jpg', 'Pièce écrite en captivité en 1940', '2026-01-31 08:00:00'),
(430, 'La Reine Albemarle ou le dernier touriste', 'Jean-Paul Sartre', 1, 12.75, 28, 'https://covers.openlibrary.org/b/id/8232325-L.jpg', 'Roman inachevé sur l\'Italie', '2026-01-31 08:00:00'),
(431, 'La Transcendance de l\'Ego', 'Jean-Paul Sartre', 1, 11.25, 32, 'https://covers.openlibrary.org/b/id/8232326-L.jpg', 'Premier essai philosophique important', '2026-01-31 08:00:00'),
(432, 'Esquisse d\'une théorie des émotions', 'Jean-Paul Sartre', 1, 10.50, 40, 'https://covers.openlibrary.org/b/id/8232327-L.jpg', 'Essai phénoménologique sur les émotions', '2026-01-31 08:00:00'),
(433, 'L\'Imagination', 'Jean-Paul Sartre', 1, 9.99, 42, 'https://covers.openlibrary.org/b/id/8232328-L.jpg', 'Premier essai sur la psychologie phénoménologique', '2026-01-31 08:00:00'),
(434, 'Visages', 'Jean-Paul Sartre', 1, 13.25, 26, 'https://covers.openlibrary.org/b/id/8232329-L.jpg', 'Préface à un livre de photos', '2026-01-31 08:00:00'),
(435, 'Plaidoyer pour les intellectuels', 'Jean-Paul Sartre', 1, 10.75, 38, 'https://covers.openlibrary.org/b/id/8232330-L.jpg', 'Conférence sur le rôle des intellectuels', '2026-01-31 08:00:00'),
(436, 'Un théâtre de situations', 'Jean-Paul Sartre', 1, 14.50, 24, 'https://covers.openlibrary.org/b/id/8232331-L.jpg', 'Recueil d\'écrits sur le théâtre', '2026-01-31 08:00:00'),
(437, 'Écrits de jeunesse', 'Jean-Paul Sartre', 1, 16.99, 18, 'https://covers.openlibrary.org/b/id/8232332-L.jpg', 'Textes écrits entre 1923 et 1940', '2026-01-31 08:00:00'),
(438, 'Les Troyennes', 'Jean-Paul Sartre', 1, 11.50, 34, 'https://covers.openlibrary.org/b/id/8232333-L.jpg', 'Adaptation de la pièce d\'Euripide', '2026-01-31 08:00:00'),
(439, 'Les Mots et autres écrits autobiographiques', 'Jean-Paul Sartre', 1, 15.25, 22, 'https://covers.openlibrary.org/b/id/8232334-L.jpg', 'Textes autobiographiques', '2026-01-31 08:00:00'),
(440, 'Lettres au Castor et à quelques autres', 'Jean-Paul Sartre', 1, 18.50, 16, 'https://covers.openlibrary.org/b/id/8232335-L.jpg', 'Correspondance avec Simone de Beauvoir', '2026-01-31 08:00:00'),
(441, 'La Cérémonie des adieux', 'Simone de Beauvoir', 1, 13.75, 28, 'https://covers.openlibrary.org/b/id/8232336-L.jpg', 'Récit des dernières années de Sartre', '2026-01-31 08:00:00'),
(442, 'Tous les hommes sont mortels', 'Simone de Beauvoir', 1, 14.50, 25, 'https://covers.openlibrary.org/b/id/8232337-L.jpg', 'Roman philosophique sur l\'immortalité', '2026-01-31 08:00:00'),
(443, 'Les Mandarins', 'Simone de Beauvoir', 1, 16.25, 20, 'https://covers.openlibrary.org/b/id/8232338-L.jpg', 'Roman sur les intellectuels parisiens après-guerre', '2026-01-31 08:00:00'),
(444, 'L\'Invitée', 'Simone de Beauvoir', 1, 13.99, 26, 'https://covers.openlibrary.org/b/id/8232339-L.jpg', 'Premier roman sur le triangle amoureux', '2026-01-31 08:00:00'),
(445, 'Le Sang des autres', 'Simone de Beauvoir', 1, 12.50, 30, 'https://covers.openlibrary.org/b/id/8232340-L.jpg', 'Roman sur la Résistance et la responsabilité', '2026-01-31 08:00:00'),
(446, 'Les Belles Images', 'Simone de Beauvoir', 1, 11.75, 32, 'https://covers.openlibrary.org/b/id/8232341-L.jpg', 'Roman sur la bourgeoisie parisienne des années 1960', '2026-01-31 08:00:00'),
(447, 'Quand prime le spirituel', 'Simone de Beauvoir', 1, 12.25, 28, 'https://covers.openlibrary.org/b/id/8232342-L.jpg', 'Premiers écrits sur la jeunesse bourgeoise', '2026-01-31 08:00:00'),
(448, 'La Femme rompue', 'Simone de Beauvoir', 1, 10.99, 36, 'https://covers.openlibrary.org/b/id/8232343-L.jpg', 'Trois nouvelles sur la condition féminine', '2026-01-31 08:00:00'),
(449, 'Une mort très douce', 'Simone de Beauvoir', 1, 9.50, 42, 'https://covers.openlibrary.org/b/id/8232344-L.jpg', 'Récit de la mort de sa mère', '2026-01-31 08:00:00'),
(450, 'Mémoires d\'une jeune fille rangée', 'Simone de Beauvoir', 1, 14.75, 24, 'https://covers.openlibrary.org/b/id/8232345-L.jpg', 'Premier tome de l\'autobiographie', '2026-01-31 08:00:00'),
(451, 'La Force de l\'âge', 'Simone de Beauvoir', 1, 16.50, 20, 'https://covers.openlibrary.org/b/id/8232346-L.jpg', 'Deuxième tome de l\'autobiographie', '2026-01-31 08:00:00'),
(452, 'La Force des choses', 'Simone de Beauvoir', 1, 17.25, 18, 'https://covers.openlibrary.org/b/id/8232347-L.jpg', 'Troisième tome de l\'autobiographie', '2026-01-31 08:00:00'),
(453, 'Tout compte fait', 'Simone de Beauvoir', 1, 15.99, 22, 'https://covers.openlibrary.org/b/id/8232348-L.jpg', 'Dernier tome de l\'autobiographie', '2026-01-31 08:00:00'),
(454, 'Le Deuxième Sexe I', 'Simone de Beauvoir', 1, 13.50, 30, 'https://covers.openlibrary.org/b/id/8232349-L.jpg', 'Premier tome de l\'œuvre fondatrice du féminisme', '2026-01-31 08:00:00'),
(455, 'Le Deuxième Sexe II', 'Simone de Beauvoir', 1, 14.25, 28, 'https://covers.openlibrary.org/b/id/8232350-L.jpg', 'Second tome de l\'œuvre féministe majeure', '2026-01-31 08:00:00'),
(456, 'Pour une morale de l\'ambiguïté', 'Simone de Beauvoir', 1, 11.25, 34, 'https://covers.openlibrary.org/b/id/8232351-L.jpg', 'Essai existentialiste sur l\'éthique', '2026-01-31 08:00:00'),
(457, 'Pyrrhus et Cinéas', 'Simone de Beauvoir', 1, 10.50, 38, 'https://covers.openlibrary.org/b/id/8232352-L.jpg', 'Premier essai philosophique', '2026-01-31 08:00:00'),
(458, 'Faut-il brûler Sade?', 'Simone de Beauvoir', 1, 12.75, 26, 'https://covers.openlibrary.org/b/id/8232353-L.jpg', 'Essai sur le marquis de Sade', '2026-01-31 08:00:00'),
(459, 'Privilèges', 'Simone de Beauvoir', 1, 13.25, 24, 'https://covers.openlibrary.org/b/id/8232354-L.jpg', 'Recueil d\'essais', '2026-01-31 08:00:00'),
(460, 'La Vieillesse', 'Simone de Beauvoir', 1, 14.99, 22, 'https://covers.openlibrary.org/b/id/8232355-L.jpg', 'Essai sociologique sur la vieillesse', '2026-01-31 08:00:00'),
(461, 'L\'Amérique au jour le jour', 'Simone de Beauvoir', 1, 13.50, 26, 'https://covers.openlibrary.org/b/id/8232356-L.jpg', 'Journal de voyage aux États-Unis', '2026-01-31 08:00:00'),
(462, 'La Longue Marche', 'Simone de Beauvoir', 1, 12.25, 30, 'https://covers.openlibrary.org/b/id/8232357-L.jpg', 'Essai sur la Chine communiste', '2026-01-31 08:00:00'),
(463, 'Djamila Boupacha', 'Simone de Beauvoir', 1, 9.75, 40, 'https://covers.openlibrary.org/b/id/8232358-L.jpg', 'Pamphlet contre la torture pendant la guerre d\'Algérie', '2026-01-31 08:00:00'),
(464, 'Les Écrits de Simone de Beauvoir', 'Simone de Beauvoir', 1, 18.50, 16, 'https://covers.openlibrary.org/b/id/8232359-L.jpg', 'Anthologie des écrits divers', '2026-01-31 08:00:00'),
(465, 'Journal de guerre', 'Simone de Beauvoir', 1, 15.25, 20, 'https://covers.openlibrary.org/b/id/8232360-L.jpg', 'Journal tenu pendant la Seconde Guerre mondiale', '2026-01-31 08:00:00'),
(466, 'Lettres à Nelson Algren', 'Simone de Beauvoir', 1, 16.99, 18, 'https://covers.openlibrary.org/b/id/8232361-L.jpg', 'Correspondance amoureuse avec l\'écrivain américain', '2026-01-31 08:00:00'),
(467, 'Lettres à Sartre', 'Simone de Beauvoir', 1, 17.50, 16, 'https://covers.openlibrary.org/b/id/8232362-L.jpg', 'Correspondance avec Jean-Paul Sartre', '2026-01-31 08:00:00'),
(468, 'Correspondance croisée', 'Simone de Beauvoir', 1, 19.99, 14, 'https://covers.openlibrary.org/b/id/8232363-L.jpg', 'Échange de lettres avec divers correspondants', '2026-01-31 08:00:00'),
(469, 'La Cérémonie des adieux suivi de Entretiens avec Jean-Paul Sartre', 'Simone de Beauvoir', 1, 14.75, 24, 'https://covers.openlibrary.org/b/id/8232364-L.jpg', 'Édition complète des derniers textes sur Sartre', '2026-01-31 08:00:00'),
(470, 'Le Capital au XXIe siècle', 'Thomas Piketty', 2, 25.99, 15, 'https://covers.openlibrary.org/b/id/8232365-L.jpg', 'Analyse des inégalités économiques contemporaines', '2026-01-31 09:00:00'),
(471, 'Capital et idéologie', 'Thomas Piketty', 2, 28.50, 12, 'https://covers.openlibrary.org/b/id/8232366-L.jpg', 'Suite du précédent ouvrage sur les idéologies inégalitaires', '2026-01-31 09:00:00'),
(472, 'Une brève histoire de l\'égalité', 'Thomas Piketty', 2, 18.99, 20, 'https://covers.openlibrary.org/b/id/8232367-L.jpg', 'Synthèse accessible sur les progrès de l\'égalité', '2026-01-31 09:00:00'),
(473, 'Les Hauts Revenus en France au XXe siècle', 'Thomas Piketty', 2, 32.00, 8, 'https://covers.openlibrary.org/b/id/8232368-L.jpg', 'Étude économique sur les inégalités en France', '2026-01-31 09:00:00'),
(474, 'L\'Économie des inégalités', 'Thomas Piketty', 2, 16.50, 25, 'https://covers.openlibrary.org/b/id/8232369-L.jpg', 'Introduction à l\'analyse économique des inégalités', '2026-01-31 09:00:00'),
(475, 'Pour un nouveau monde', 'Thomas Piketty', 2, 19.99, 18, 'https://covers.openlibrary.org/b/id/8232370-L.jpg', 'Essai politique sur les alternatives économiques', '2026-01-31 09:00:00'),
(476, 'Le Sacre de la démocratie', 'Thomas Piketty', 2, 21.50, 15, 'https://covers.openlibrary.org/b/id/8232371-L.jpg', 'Réflexion sur l\'avenir de la démocratie', '2026-01-31 09:00:00'),
(477, 'Théorie de la justice', 'John Rawls', 2, 24.99, 10, 'https://covers.openlibrary.org/b/id/8232372-L.jpg', 'Ouvrage fondateur de la philosophie politique contemporaine', '2026-01-31 09:00:00'),
(478, 'Libéralisme politique', 'John Rawls', 2, 22.50, 12, 'https://covers.openlibrary.org/b/id/8232373-L.jpg', 'Développement des idées de justice dans un contexte pluraliste', '2026-01-31 09:00:00'),
(479, 'Le Droit des gens', 'John Rawls', 2, 18.75, 16, 'https://covers.openlibrary.org/b/id/8232374-L.jpg', 'Extension de la théorie de la justice aux relations internationales', '2026-01-31 09:00:00'),
(480, 'Justice et démocratie', 'John Rawls', 2, 20.99, 14, 'https://covers.openlibrary.org/b/id/8232375-L.jpg', 'Recueil d\'articles sur la philosophie politique', '2026-01-31 09:00:00'),
(481, 'Histoire de la philosophie occidentale', 'Bertrand Russell', 2, 29.99, 8, 'https://covers.openlibrary.org/b/id/8232376-L.jpg', 'Synthèse magistrale de la pensée occidentale', '2026-01-31 09:00:00'),
(482, 'Pourquoi je ne suis pas chrétien', 'Bertrand Russell', 2, 15.50, 22, 'https://covers.openlibrary.org/b/id/8232377-L.jpg', 'Essai critique sur la religion', '2026-01-31 09:00:00'),
(483, 'Science et religion', 'Bertrand Russell', 2, 16.75, 20, 'https://covers.openlibrary.org/b/id/8232378-L.jpg', 'Analyse des relations entre science et croyance', '2026-01-31 09:00:00'),
(484, 'L\'ABC de la relativité', 'Bertrand Russell', 2, 14.99, 25, 'https://covers.openlibrary.org/b/id/8232379-L.jpg', 'Introduction accessible à la théorie de la relativité', '2026-01-31 09:00:00'),
(485, 'Le Monde qui pourrait être', 'Bertrand Russell', 2, 17.50, 18, 'https://covers.openlibrary.org/b/id/8232380-L.jpg', 'Essai utopique sur une société meilleure', '2026-01-31 09:00:00'),
(486, 'Essais sceptiques', 'Bertrand Russell', 2, 18.25, 16, 'https://covers.openlibrary.org/b/id/8232381-L.jpg', 'Recueil d\'essais philosophiques', '2026-01-31 09:00:00'),
(487, 'La Conquête du bonheur', 'Bertrand Russell', 2, 15.99, 24, 'https://covers.openlibrary.org/b/id/8232382-L.jpg', 'Guide pratique pour une vie épanouie', '2026-01-31 09:00:00');
INSERT INTO `books` (`id`, `title`, `author`, `category_id`, `price`, `stock`, `image_url`, `description`, `created_at`) VALUES
(488, 'Marriage and Morals', 'Bertrand Russell', 2, 16.50, 22, 'https://covers.openlibrary.org/b/id/8232383-L.jpg', 'Réflexion sur l\'éthique des relations conjugales', '2026-01-31 09:00:00'),
(489, 'L\'Analyse de l\'esprit', 'Bertrand Russell', 2, 19.75, 15, 'https://covers.openlibrary.org/b/id/8232384-L.jpg', 'Étude philosophique de la psychologie', '2026-01-31 09:00:00'),
(490, 'La Philosophie de l\'atomisme logique', 'Bertrand Russell', 2, 17.25, 18, 'https://covers.openlibrary.org/b/id/8232385-L.jpg', 'Exposé de sa théorie philosophique', '2026-01-31 09:00:00'),
(491, 'My Philosophical Development', 'Bertrand Russell', 2, 20.50, 14, 'https://covers.openlibrary.org/b/id/8232386-L.jpg', 'Autobiographie intellectuelle', '2026-01-31 09:00:00'),
(492, 'The Problems of Philosophy', 'Bertrand Russell', 2, 13.99, 28, 'https://covers.openlibrary.org/b/id/8232387-L.jpg', 'Introduction à la philosophie', '2026-01-31 09:00:00'),
(493, 'An Inquiry into Meaning and Truth', 'Bertrand Russell', 2, 18.99, 16, 'https://covers.openlibrary.org/b/id/8232388-L.jpg', 'Étude de la philosophie du langage', '2026-01-31 09:00:00'),
(494, 'Human Knowledge: Its Scope and Limits', 'Bertrand Russell', 2, 21.25, 12, 'https://covers.openlibrary.org/b/id/8232389-L.jpg', 'Épistémologie et limites de la connaissance humaine', '2026-01-31 09:00:00'),
(495, 'Power: A New Social Analysis', 'Bertrand Russell', 2, 16.75, 20, 'https://covers.openlibrary.org/b/id/8232390-L.jpg', 'Analyse sociologique du pouvoir', '2026-01-31 09:00:00'),
(496, 'Unpopular Essays', 'Bertrand Russell', 2, 15.50, 22, 'https://covers.openlibrary.org/b/id/8232391-L.jpg', 'Recueil d\'essais sur divers sujets', '2026-01-31 09:00:00'),
(497, 'Fact and Fiction', 'Bertrand Russell', 2, 17.99, 18, 'https://covers.openlibrary.org/b/id/8232392-L.jpg', 'Mélange de fiction et de réflexion philosophique', '2026-01-31 09:00:00'),
(498, 'The Scientific Outlook', 'Bertrand Russell', 2, 16.25, 20, 'https://covers.openlibrary.org/b/id/8232393-L.jpg', 'Réflexion sur la science et son impact social', '2026-01-31 09:00:00'),
(499, 'An Outline of Philosophy', 'Bertrand Russell', 2, 19.50, 15, 'https://covers.openlibrary.org/b/id/8232394-L.jpg', 'Présentation générale de la philosophie', '2026-01-31 09:00:00'),
(500, 'What I Believe', 'Bertrand Russell', 2, 12.99, 30, 'https://covers.openlibrary.org/b/id/8232395-L.jpg', 'Exposé de ses convictions personnelles', '2026-01-31 09:00:00'),
(501, 'In Praise of Idleness', 'Bertrand Russell', 2, 14.75, 24, 'https://covers.openlibrary.org/b/id/8232396-L.jpg', 'Essai sur l\'oisiveté et le travail', '2026-01-31 09:00:00'),
(502, 'The Impact of Science on Society', 'Bertrand Russell', 2, 15.99, 22, 'https://covers.openlibrary.org/b/id/8232397-L.jpg', 'Analyse de l\'influence de la science', '2026-01-31 09:00:00'),
(503, 'New Hopes for a Changing World', 'Bertrand Russell', 2, 16.50, 20, 'https://covers.openlibrary.org/b/id/8232398-L.jpg', 'Essai optimiste sur l\'avenir', '2026-01-31 09:00:00'),
(504, 'Understanding History', 'Bertrand Russell', 2, 17.25, 18, 'https://covers.openlibrary.org/b/id/8232399-L.jpg', 'Réflexion philosophique sur l\'histoire', '2026-01-31 09:00:00'),
(505, 'Logic and Knowledge', 'Bertrand Russell', 2, 20.99, 14, 'https://covers.openlibrary.org/b/id/8232400-L.jpg', 'Essais sur la logique et la connaissance', '2026-01-31 09:00:00'),
(506, 'Essays in Analysis', 'Bertrand Russell', 2, 18.75, 16, 'https://covers.openlibrary.org/b/id/8232401-L.jpg', 'Recueil d\'essais philosophiques techniques', '2026-01-31 09:00:00'),
(507, 'The Philosophy of Bertrand Russell', 'Bertrand Russell', 2, 22.50, 12, 'https://covers.openlibrary.org/b/id/8232402-L.jpg', 'Anthologie de ses principaux écrits', '2026-01-31 09:00:00'),
(508, 'The Autobiography of Bertrand Russell', 'Bertrand Russell', 2, 24.99, 10, 'https://covers.openlibrary.org/b/id/8232403-L.jpg', 'Autobiographie en trois volumes', '2026-01-31 09:00:00'),
(509, 'The Collected Papers of Bertrand Russell', 'Bertrand Russell', 2, 35.00, 6, 'https://covers.openlibrary.org/b/id/8232404-L.jpg', 'Édition complète de ses écrits', '2026-01-31 09:00:00'),
(510, 'Principia Mathematica', 'Alfred North Whitehead', 2, 45.99, 4, 'https://covers.openlibrary.org/b/id/8232405-L.jpg', 'Œuvre monumentale sur les fondements des mathématiques', '2026-01-31 09:00:00'),
(511, 'Process and Reality', 'Alfred North Whitehead', 2, 28.50, 8, 'https://covers.openlibrary.org/b/id/8232406-L.jpg', 'Exposé de la philosophie du procès', '2026-01-31 09:00:00'),
(512, 'Science and the Modern World', 'Alfred North Whitehead', 2, 19.99, 16, 'https://covers.openlibrary.org/b/id/8232407-L.jpg', 'Analyse de l\'impact de la science sur la civilisation', '2026-01-31 09:00:00'),
(513, 'Adventures of Ideas', 'Alfred North Whitehead', 2, 21.75, 12, 'https://covers.openlibrary.org/b/id/8232408-L.jpg', 'Histoire des idées dans la civilisation occidentale', '2026-01-31 09:00:00'),
(514, 'Modes of Thought', 'Alfred North Whitehead', 2, 18.50, 15, 'https://covers.openlibrary.org/b/id/8232409-L.jpg', 'Introduction à sa philosophie', '2026-01-31 09:00:00'),
(515, 'The Aims of Education', 'Alfred North Whitehead', 2, 16.99, 20, 'https://covers.openlibrary.org/b/id/8232410-L.jpg', 'Essais sur la philosophie de l\'éducation', '2026-01-31 09:00:00'),
(516, 'Symbolism: Its Meaning and Effect', 'Alfred North Whitehead', 2, 15.50, 22, 'https://covers.openlibrary.org/b/id/8232411-L.jpg', 'Étude philosophique du symbolisme', '2026-01-31 09:00:00'),
(517, 'Religion in the Making', 'Alfred North Whitehead', 2, 17.25, 18, 'https://covers.openlibrary.org/b/id/8232412-L.jpg', 'Analyse philosophique de la religion', '2026-01-31 09:00:00'),
(518, 'The Function of Reason', 'Alfred North Whitehead', 2, 14.99, 24, 'https://covers.openlibrary.org/b/id/8232413-L.jpg', 'Essai sur la nature et le rôle de la raison', '2026-01-31 09:00:00'),
(519, 'An Enquiry Concerning the Principles of Natural Knowledge', 'Alfred North Whitehead', 2, 19.50, 14, 'https://covers.openlibrary.org/b/id/8232414-L.jpg', 'Étude épistémologique', '2026-01-31 09:00:00'),
(520, 'The Concept of Nature', 'Alfred North Whitehead', 2, 18.75, 16, 'https://covers.openlibrary.org/b/id/8232415-L.jpg', 'Analyse philosophique de la nature', '2026-01-31 09:00:00'),
(521, 'The Principle of Relativity', 'Alfred North Whitehead', 2, 20.99, 12, 'https://covers.openlibrary.org/b/id/8232416-L.jpg', 'Application de la relativité en philosophie', '2026-01-31 09:00:00'),
(522, 'Essays in Science and Philosophy', 'Alfred North Whitehead', 2, 22.50, 10, 'https://covers.openlibrary.org/b/id/8232417-L.jpg', 'Recueil d\'essais variés', '2026-01-31 09:00:00'),
(523, 'The Interpretation of Science', 'Alfred North Whitehead', 2, 21.25, 11, 'https://covers.openlibrary.org/b/id/8232418-L.jpg', 'Réflexion sur la nature de la science', '2026-01-31 09:00:00'),
(524, 'Whitehead\'s American Essays in Social Philosophy', 'Alfred North Whitehead', 2, 17.99, 18, 'https://covers.openlibrary.org/b/id/8232419-L.jpg', 'Essais sur la philosophie sociale', '2026-01-31 09:00:00'),
(525, 'The Philosophy of Alfred North Whitehead', 'Alfred North Whitehead', 2, 24.99, 8, 'https://covers.openlibrary.org/b/id/8232420-L.jpg', 'Anthologie de ses principaux écrits', '2026-01-31 09:00:00'),
(526, 'The Wit and Wisdom of Whitehead', 'Alfred North Whitehead', 2, 16.50, 20, 'https://covers.openlibrary.org/b/id/8232421-L.jpg', 'Sélection de citations et aphorismes', '2026-01-31 09:00:00'),
(527, 'Whitehead\'s Theory of Reality', 'Alfred North Whitehead', 2, 19.75, 14, 'https://covers.openlibrary.org/b/id/8232422-L.jpg', 'Exposé systématique de sa métaphysique', '2026-01-31 09:00:00'),
(528, 'The Essential Whitehead', 'Alfred North Whitehead', 2, 18.99, 16, 'https://covers.openlibrary.org/b/id/8232423-L.jpg', 'Sélection de textes fondamentaux', '2026-01-31 09:00:00'),
(529, 'Whitehead\'s Philosophy of Organism', 'Alfred North Whitehead', 2, 21.50, 12, 'https://covers.openlibrary.org/b/id/8232424-L.jpg', 'Présentation de sa philosophie biologique', '2026-01-31 09:00:00'),
(530, 'The Relevance of Whitehead', 'Alfred North Whitehead', 2, 17.25, 18, 'https://covers.openlibrary.org/b/id/8232425-L.jpg', 'Essai sur l\'actualité de sa pensée', '2026-01-31 09:00:00'),
(531, 'Whitehead and Modern Science', 'Alfred North Whitehead', 2, 20.00, 13, 'https://covers.openlibrary.org/b/id/8232426-L.jpg', 'Analyse des relations avec la science contemporaine', '2026-01-31 09:00:00'),
(532, 'Process Studies: An Introduction', 'Alfred North Whitehead', 2, 16.99, 20, 'https://covers.openlibrary.org/b/id/8232427-L.jpg', 'Introduction à la philosophie du procès', '2026-01-31 09:00:00'),
(533, 'The Cambridge Companion to Whitehead', 'Alfred North Whitehead', 2, 23.50, 9, 'https://covers.openlibrary.org/b/id/8232428-L.jpg', 'Guide critique de sa philosophie', '2026-01-31 09:00:00'),
(534, 'Whitehead\'s Metaphysics of Creativity', 'Alfred North Whitehead', 2, 19.25, 15, 'https://covers.openlibrary.org/b/id/8232429-L.jpg', 'Étude de son concept central de créativité', '2026-01-31 09:00:00'),
(535, 'The Philosophy of Mathematics', 'Alfred North Whitehead', 2, 22.75, 10, 'https://covers.openlibrary.org/b/id/8232430-L.jpg', 'Réflexion sur les fondements des mathématiques', '2026-01-31 09:00:00'),
(536, 'Whitehead and the Idea of Process', 'Alfred North Whitehead', 2, 18.50, 17, 'https://covers.openlibrary.org/b/id/8232431-L.jpg', 'Explication du concept de procès', '2026-01-31 09:00:00'),
(537, 'The Social Thought of Whitehead', 'Alfred North Whitehead', 2, 17.99, 19, 'https://covers.openlibrary.org/b/id/8232432-L.jpg', 'Application de sa philosophie aux sciences sociales', '2026-01-31 09:00:00'),
(538, 'Whitehead\'s Philosophy of Education', 'Alfred North Whitehead', 2, 16.25, 21, 'https://covers.openlibrary.org/b/id/8232433-L.jpg', 'Pédagogie inspirée de sa philosophie', '2026-01-31 09:00:00'),
(539, 'The Religious Philosophy of Whitehead', 'Alfred North Whitehead', 2, 19.99, 14, 'https://covers.openlibrary.org/b/id/8232434-L.jpg', 'Analyse de sa pensée religieuse', '2026-01-31 09:00:00'),
(540, 'Whitehead and Analytic Philosophy', 'Alfred North Whitehead', 2, 21.50, 12, 'https://covers.openlibrary.org/b/id/8232435-L.jpg', 'Comparaison avec la philosophie analytique', '2026-01-31 09:00:00'),
(541, 'Le Petit Prince retrouvé', 'Jean-Pierre Davidts', 3, 14.99, 30, 'https://covers.openlibrary.org/b/id/8232436-L.jpg', 'Suite officieuse des aventures du Petit Prince', '2026-01-31 10:00:00'),
(542, 'Le Petit Prince et le Renard', 'Adaptation', 3, 12.50, 35, 'https://covers.openlibrary.org/b/id/8232437-L.jpg', 'Adaptation jeunesse de l\'histoire d\'amitié', '2026-01-31 10:00:00'),
(543, 'Le Petit Prince - Édition illustrée', 'Antoine de Saint-Exupéry', 3, 19.99, 25, 'https://covers.openlibrary.org/b/id/8232438-L.jpg', 'Édition de luxe avec illustrations originales', '2026-01-31 10:00:00'),
(544, 'Le Petit Prince - Cahier d\'activités', 'Divers auteurs', 3, 9.99, 45, 'https://covers.openlibrary.org/b/id/8232439-L.jpg', 'Livre-jeux pour enfants inspiré du Petit Prince', '2026-01-31 10:00:00'),
(545, 'Les Citations du Petit Prince', 'Antoine de Saint-Exupéry', 3, 8.50, 50, 'https://covers.openlibrary.org/b/id/8232440-L.jpg', 'Recueil des plus belles phrases du livre', '2026-01-31 10:00:00'),
(546, 'Le Petit Prince - Version audio', 'Antoine de Saint-Exupéry', 3, 15.50, 28, 'https://covers.openlibrary.org/b/id/8232441-L.jpg', 'Livre audio avec lecture par un comédien', '2026-01-31 10:00:00'),
(547, 'Le Petit Prince - Édition scolaire', 'Antoine de Saint-Exupéry', 3, 7.99, 60, 'https://covers.openlibrary.org/b/id/8232442-L.jpg', 'Édition annotée pour les collégiens', '2026-01-31 10:00:00'),
(548, 'Le Petit Prince - En bande dessinée', 'Adaptation BD', 3, 13.75, 32, 'https://covers.openlibrary.org/b/id/8232443-L.jpg', 'Adaptation en bande dessinée fidèle au texte', '2026-01-31 10:00:00'),
(549, 'Le Petit Prince - Livre pop-up', 'Antoine de Saint-Exupéry', 3, 22.99, 20, 'https://covers.openlibrary.org/b/id/8232444-L.jpg', 'Édition avec animations en relief', '2026-01-31 10:00:00'),
(550, 'Le Petit Prince - Édition bilingue', 'Antoine de Saint-Exupéry', 3, 16.50, 26, 'https://covers.openlibrary.org/b/id/8232445-L.jpg', 'Texte français-anglais en regard', '2026-01-31 10:00:00'),
(551, 'Le Petit Prince - Carnet de dessin', 'Divers auteurs', 3, 11.25, 40, 'https://covers.openlibrary.org/b/id/8232446-L.jpg', 'Carnet pour apprendre à dessiner les personnages', '2026-01-31 10:00:00'),
(552, 'Le Petit Prince - Guide pédagogique', 'Enseignants', 3, 14.50, 24, 'https://covers.openlibrary.org/b/id/8232447-L.jpg', 'Guide pour enseignants avec fiches d\'activités', '2026-01-31 10:00:00'),
(553, 'Le Petit Prince - Édition collector', 'Antoine de Saint-Exupéry', 3, 29.99, 15, 'https://covers.openlibrary.org/b/id/8232448-L.jpg', 'Édition numérotée avec jaquette spéciale', '2026-01-31 10:00:00'),
(554, 'Le Petit Prince - Livre puzzle', 'Adaptation jeu', 3, 18.75, 22, 'https://covers.openlibrary.org/b/id/8232449-L.jpg', 'Livre avec puzzles intégrés', '2026-01-31 10:00:00'),
(555, 'Le Petit Prince - Histoire du soir', 'Adaptation', 3, 12.99, 38, 'https://covers.openlibrary.org/b/id/8232450-L.jpg', 'Adaptation pour les tout-petits', '2026-01-31 10:00:00'),
(556, 'Le Petit Prince - Mon premier livre', 'Antoine de Saint-Exupéry', 3, 10.50, 42, 'https://covers.openlibrary.org/b/id/8232451-L.jpg', 'Version simplifiée pour jeunes lecteurs', '2026-01-31 10:00:00'),
(557, 'Le Petit Prince - Cahier de coloriage', 'Divers auteurs', 3, 6.99, 55, 'https://covers.openlibrary.org/b/id/8232452-L.jpg', 'Coloriages des personnages et scènes célèbres', '2026-01-31 10:00:00'),
(558, 'Le Petit Prince - Édition de poche illustrée', 'Antoine de Saint-Exupéry', 3, 9.25, 48, 'https://covers.openlibrary.org/b/id/8232453-L.jpg', 'Édition économique avec illustrations', '2026-01-31 10:00:00'),
(559, 'Le Petit Prince - Livre musical', 'Adaptation musicale', 3, 21.50, 18, 'https://covers.openlibrary.org/b/id/8232454-L.jpg', 'Livre avec puces sonores et musiques', '2026-01-31 10:00:00'),
(560, 'Le Petit Prince - Édition annotée', 'Antoine de Saint-Exupéry', 3, 17.99, 25, 'https://covers.openlibrary.org/b/id/8232455-L.jpg', 'Édition critique avec notes explicatives', '2026-01-31 10:00:00'),
(561, 'Harry Potter et la Chambre des Secrets', 'J.K. Rowling', 3, 10.99, 55, 'https://covers.openlibrary.org/b/id/8232456-L.jpg', 'Deuxième tome des aventures de Harry Potter', '2026-01-31 10:00:00'),
(562, 'Harry Potter et le Prisonnier d\'Azkaban', 'J.K. Rowling', 3, 11.50, 50, 'https://covers.openlibrary.org/b/id/8232457-L.jpg', 'Troisième tome avec Sirius Black', '2026-01-31 10:00:00'),
(563, 'Harry Potter et la Coupe de Feu', 'J.K. Rowling', 3, 12.99, 45, 'https://covers.openlibrary.org/b/id/8232458-L.jpg', 'Quatrième tome et tournoi des trois sorciers', '2026-01-31 10:00:00'),
(564, 'Harry Potter et l\'Ordre du Phénix', 'J.K. Rowling', 3, 13.75, 40, 'https://covers.openlibrary.org/b/id/8232459-L.jpg', 'Cinquième tome et création de l\'Armée de Dumbledore', '2026-01-31 10:00:00'),
(565, 'Harry Potter et le Prince de Sang-Mêlé', 'J.K. Rowling', 3, 12.50, 42, 'https://covers.openlibrary.org/b/id/8232460-L.jpg', 'Sixième tome et passé de Voldemort', '2026-01-31 10:00:00'),
(566, 'Harry Potter et les Reliques de la Mort', 'J.K. Rowling', 3, 14.99, 38, 'https://covers.openlibrary.org/b/id/8232461-L.jpg', 'Dernier tome et bataille finale', '2026-01-31 10:00:00'),
(567, 'Harry Potter - L\'histoire complète', 'J.K. Rowling', 3, 24.99, 25, 'https://covers.openlibrary.org/b/id/8232462-L.jpg', 'Édition intégrale des sept tomes', '2026-01-31 10:00:00'),
(568, 'Harry Potter - Le grimoire des sorts', 'J.K. Rowling', 3, 18.50, 30, 'https://covers.openlibrary.org/b/id/8232463-L.jpg', 'Guide des sorts et potions de l\'univers Harry Potter', '2026-01-31 10:00:00'),
(569, 'Harry Potter - Les animaux fantastiques', 'J.K. Rowling', 3, 16.99, 32, 'https://covers.openlibrary.org/b/id/8232464-L.jpg', 'Bestiaire des créatures magiques', '2026-01-31 10:00:00'),
(570, 'Harry Potter - Le Quidditch à travers les âges', 'J.K. Rowling', 3, 15.75, 35, 'https://covers.openlibrary.org/b/id/8232465-L.jpg', 'Histoire du sport préféré des sorciers', '2026-01-31 10:00:00'),
(571, 'Harry Potter - Les contes de Beedle le Barde', 'J.K. Rowling', 3, 14.25, 36, 'https://covers.openlibrary.org/b/id/8232466-L.jpg', 'Contes pour enfants sorciers', '2026-01-31 10:00:00'),
(572, 'Harry Potter - Édition illustrée T1', 'J.K. Rowling', 3, 29.99, 20, 'https://covers.openlibrary.org/b/id/8232467-L.jpg', 'Premier tome avec illustrations de Jim Kay', '2026-01-31 10:00:00'),
(573, 'Harry Potter - Édition illustrée T2', 'J.K. Rowling', 3, 31.50, 18, 'https://covers.openlibrary.org/b/id/8232468-L.jpg', 'Deuxième tome illustré', '2026-01-31 10:00:00'),
(574, 'Harry Potter - Édition illustrée T3', 'J.K. Rowling', 3, 32.99, 16, 'https://covers.openlibrary.org/b/id/8232469-L.jpg', 'Troisième tome illustré', '2026-01-31 10:00:00'),
(575, 'Harry Potter - Édition illustrée T4', 'J.K. Rowling', 3, 34.50, 14, 'https://covers.openlibrary.org/b/id/8232470-L.jpg', 'Quatrième tome illustré', '2026-01-31 10:00:00'),
(576, 'Harry Potter - Cahier de coloriage', 'J.K. Rowling', 3, 9.99, 50, 'https://covers.openlibrary.org/b/id/8232471-L.jpg', 'Coloriages des personnages et lieux magiques', '2026-01-31 10:00:00'),
(577, 'Harry Potter - Livre-jeux', 'J.K. Rowling', 3, 12.50, 40, 'https://covers.openlibrary.org/b/id/8232472-L.jpg', 'Jeux et énigmes sur l\'univers Harry Potter', '2026-01-31 10:00:00'),
(578, 'Harry Potter - Guide des films', 'J.K. Rowling', 3, 19.99, 28, 'https://covers.openlibrary.org/b/id/8232473-L.jpg', 'Making-of et secrets de tournage', '2026-01-31 10:00:00'),
(579, 'Harry Potter - Encyclopédie', 'J.K. Rowling', 3, 22.50, 24, 'https://covers.openlibrary.org/b/id/8232474-L.jpg', 'Guide complet de l\'univers', '2026-01-31 10:00:00'),
(580, 'Harry Potter - Édition collector', 'J.K. Rowling', 3, 49.99, 12, 'https://covers.openlibrary.org/b/id/8232475-L.jpg', 'Coffret luxe des sept tomes', '2026-01-31 10:00:00'),
(581, 'Harry Potter - Livre audio T1', 'J.K. Rowling', 3, 24.99, 22, 'https://covers.openlibrary.org/b/id/8232476-L.jpg', 'Version audio lue par Bernard Giraudeau', '2026-01-31 10:00:00'),
(582, 'Harry Potter - Livre audio T2', 'J.K. Rowling', 3, 25.50, 20, 'https://covers.openlibrary.org/b/id/8232477-L.jpg', 'Deuxième tome en version audio', '2026-01-31 10:00:00'),
(583, 'Harry Potter - Livre audio T3', 'J.K. Rowling', 3, 26.99, 18, 'https://covers.openlibrary.org/b/id/8232478-L.jpg', 'Troisième tome en version audio', '2026-01-31 10:00:00'),
(584, 'Harry Potter - Livre audio T4', 'J.K. Rowling', 3, 28.50, 16, 'https://covers.openlibrary.org/b/id/8232479-L.jpg', 'Quatrième tome en version audio', '2026-01-31 10:00:00'),
(585, 'Harry Potter - Édition scolaire T1', 'J.K. Rowling', 3, 8.99, 60, 'https://covers.openlibrary.org/b/id/8232480-L.jpg', 'Premier tome annoté pour collégiens', '2026-01-31 10:00:00'),
(586, 'Harry Potter - Édition scolaire T2', 'J.K. Rowling', 3, 9.25, 55, 'https://covers.openlibrary.org/b/id/8232481-L.jpg', 'Deuxième tome annoté', '2026-01-31 10:00:00'),
(587, 'Harry Potter - Édition scolaire T3', 'J.K. Rowling', 3, 9.75, 50, 'https://covers.openlibrary.org/b/id/8232482-L.jpg', 'Troisième tome annoté', '2026-01-31 10:00:00'),
(588, 'Harry Potter - Mon premier livre', 'J.K. Rowling', 3, 11.99, 45, 'https://covers.openlibrary.org/b/id/8232483-L.jpg', 'Adaptation simplifiée pour jeunes enfants', '2026-01-31 10:00:00'),
(589, 'Harry Potter - Livre pop-up', 'J.K. Rowling', 3, 27.50, 18, 'https://covers.openlibrary.org/b/id/8232484-L.jpg', 'Livre animé avec scènes en relief', '2026-01-31 10:00:00'),
(590, 'Harry Potter - Édition bilingue T1', 'J.K. Rowling', 3, 15.99, 32, 'https://covers.openlibrary.org/b/id/8232485-L.jpg', 'Texte français-anglais', '2026-01-31 10:00:00'),
(591, 'Harry Potter - Carnet de dessin', 'J.K. Rowling', 3, 13.50, 38, 'https://covers.openlibrary.org/b/id/8232486-L.jpg', 'Apprendre à dessiner les personnages', '2026-01-31 10:00:00'),
(592, 'Harry Potter - Guide pédagogique', 'Enseignants', 3, 16.75, 26, 'https://covers.openlibrary.org/b/id/8232487-L.jpg', 'Ressources pour enseignants', '2026-01-31 10:00:00'),
(593, 'Harry Potter - Édition de poche T1', 'J.K. Rowling', 3, 7.99, 65, 'https://covers.openlibrary.org/b/id/8232488-L.jpg', 'Premier tome en format poche', '2026-01-31 10:00:00'),
(594, 'Harry Potter - Édition de poche T2', 'J.K. Rowling', 3, 8.25, 60, 'https://covers.openlibrary.org/b/id/8232489-L.jpg', 'Deuxième tome en poche', '2026-01-31 10:00:00'),
(595, 'Harry Potter - Édition de poche T3', 'J.K. Rowling', 3, 8.50, 58, 'https://covers.openlibrary.org/b/id/8232490-L.jpg', 'Troisième tome en poche', '2026-01-31 10:00:00'),
(596, 'Harry Potter - Édition de poche T4', 'J.K. Rowling', 3, 8.75, 55, 'https://covers.openlibrary.org/b/id/8232491-L.jpg', 'Quatrième tome en poche', '2026-01-31 10:00:00'),
(597, 'Harry Potter - Livre musical', 'J.K. Rowling', 3, 23.99, 22, 'https://covers.openlibrary.org/b/id/8232492-L.jpg', 'Livre avec puces sonores et musiques des films', '2026-01-31 10:00:00'),
(598, 'Harry Potter - Édition annotée T1', 'J.K. Rowling', 3, 19.50, 28, 'https://covers.openlibrary.org/b/id/8232493-L.jpg', 'Premier tome avec notes critiques', '2026-01-31 10:00:00'),
(599, 'Le Petit Nicolas - Les vacances', 'René Goscinny', 3, 9.50, 48, 'https://covers.openlibrary.org/b/id/8232494-L.jpg', 'Nouvelles aventures du Petit Nicolas en vacances', '2026-01-31 10:00:00'),
(600, 'Le Petit Nicolas - À l\'école', 'René Goscinny', 3, 9.25, 50, 'https://covers.openlibrary.org/b/id/8232495-L.jpg', 'Histoires de la vie scolaire', '2026-01-31 10:00:00'),
(601, 'Le Petit Nicolas - Les copains', 'René Goscinny', 3, 9.75, 46, 'https://covers.openlibrary.org/b/id/8232496-L.jpg', 'Aventures avec Alceste, Eudes et les autres', '2026-01-31 10:00:00'),
(602, 'Le Petit Nicolas - En famille', 'René Goscinny', 3, 10.25, 42, 'https://covers.openlibrary.org/b/id/8232497-L.jpg', 'Histoires avec ses parents', '2026-01-31 10:00:00'),
(603, 'Le Petit Nicolas - Intégrale', 'René Goscinny', 3, 24.99, 25, 'https://covers.openlibrary.org/b/id/8232498-L.jpg', 'Toutes les histoires en un volume', '2026-01-31 10:00:00'),
(604, 'Le Petit Nicolas - Cahier de coloriage', 'René Goscinny', 3, 7.99, 55, 'https://covers.openlibrary.org/b/id/8232499-L.jpg', 'Coloriages des personnages', '2026-01-31 10:00:00'),
(605, 'Le Petit Nicolas - Livre-jeux', 'René Goscinny', 3, 11.50, 40, 'https://covers.openlibrary.org/b/id/8232500-L.jpg', 'Jeux et énigmes autour des histoires', '2026-01-31 10:00:00'),
(606, 'Le Petit Nicolas - Édition illustrée', 'René Goscinny', 3, 16.99, 32, 'https://covers.openlibrary.org/b/id/8232501-L.jpg', 'Nouvelles illustrations colorées', '2026-01-31 10:00:00'),
(607, 'Le Petit Nicolas - Livre audio', 'René Goscinny', 3, 18.50, 28, 'https://covers.openlibrary.org/b/id/8232502-L.jpg', 'Histoires lues par un comédien', '2026-01-31 10:00:00'),
(608, 'Le Petit Nicolas - Édition scolaire', 'René Goscinny', 3, 8.50, 52, 'https://covers.openlibrary.org/b/id/8232503-L.jpg', 'Édition annotée pour l\'école', '2026-01-31 10:00:00'),
(609, 'Fondation et Terre', 'Isaac Asimov', 4, 15.99, 30, 'https://covers.openlibrary.org/b/id/8232504-L.jpg', 'Cinquième tome du cycle de Fondation', '2026-01-31 11:00:00'),
(610, 'Prélude à Fondation', 'Isaac Asimov', 4, 16.50, 28, 'https://covers.openlibrary.org/b/id/8232505-L.jpg', 'Préquelle du cycle de Fondation', '2026-01-31 11:00:00'),
(611, 'L\'Aube de Fondation', 'Isaac Asimov', 4, 17.25, 25, 'https://covers.openlibrary.org/b/id/8232506-L.jpg', 'Deuxième préquelle de Fondation', '2026-01-31 11:00:00'),
(612, 'Fondation foudroyée', 'Isaac Asimov', 4, 15.75, 32, 'https://covers.openlibrary.org/b/id/8232507-L.jpg', 'Sixième tome de Fondation', '2026-01-31 11:00:00'),
(613, 'Terre et Fondation', 'Isaac Asimov', 4, 16.99, 26, 'https://covers.openlibrary.org/b/id/8232508-L.jpg', 'Dernier tome de Fondation', '2026-01-31 11:00:00'),
(614, 'Le Cycle de Fondation - Intégrale', 'Isaac Asimov', 4, 39.99, 15, 'https://covers.openlibrary.org/b/id/8232509-L.jpg', 'Les sept tomes en un volume', '2026-01-31 11:00:00'),
(615, 'Les Cavernes d\'acier', 'Isaac Asimov', 4, 13.50, 35, 'https://covers.openlibrary.org/b/id/8232510-L.jpg', 'Premier roman policier de science-fiction', '2026-01-31 11:00:00'),
(616, 'Face aux feux du soleil', 'Isaac Asimov', 4, 14.25, 32, 'https://covers.openlibrary.org/b/id/8232511-L.jpg', 'Suite des Cavernes d\'acier', '2026-01-31 11:00:00'),
(617, 'Les Robots de l\'aube', 'Isaac Asimov', 4, 15.50, 28, 'https://covers.openlibrary.org/b/id/8232512-L.jpg', 'Troisième enquête d\'Elijah Baley', '2026-01-31 11:00:00'),
(618, 'Les Robots et l\'Empire', 'Isaac Asimov', 4, 16.75, 24, 'https://covers.openlibrary.org/b/id/8232513-L.jpg', 'Quatrième et dernier roman des robots', '2026-01-31 11:00:00'),
(619, 'Un défilé de robots', 'Isaac Asimov', 4, 12.99, 38, 'https://covers.openlibrary.org/b/id/8232514-L.jpg', 'Recueil de nouvelles sur les robots', '2026-01-31 11:00:00'),
(620, 'Nous les robots', 'Isaac Asimov', 4, 13.75, 34, 'https://covers.openlibrary.org/b/id/8232515-L.jpg', 'Autre recueil de nouvelles robotiques', '2026-01-31 11:00:00'),
(621, 'Le Robot qui rêvait', 'Isaac Asimov', 4, 14.50, 30, 'https://covers.openlibrary.org/b/id/8232516-L.jpg', 'Nouvelles sur l\'intelligence artificielle', '2026-01-31 11:00:00'),
(622, 'Les Courants de l\'espace', 'Isaac Asimov', 4, 13.25, 36, 'https://covers.openlibrary.org/b/id/8232517-L.jpg', 'Roman de l\'Empire galactique', '2026-01-31 11:00:00'),
(623, 'Poussière d\'étoiles', 'Isaac Asimov', 4, 12.50, 40, 'https://covers.openlibrary.org/b/id/8232518-L.jpg', 'Deuxième roman de l\'Empire', '2026-01-31 11:00:00'),
(624, 'Cailloux dans le ciel', 'Isaac Asimov', 4, 11.99, 42, 'https://covers.openlibrary.org/b/id/8232519-L.jpg', 'Troisième roman de l\'Empire', '2026-01-31 11:00:00'),
(625, 'L\'Homme bicentenaire', 'Isaac Asimov', 4, 10.75, 46, 'https://covers.openlibrary.org/b/id/8232520-L.jpg', 'Nouvelle célèbre sur un robot conscient', '2026-01-31 11:00:00'),
(626, 'Le Guide de la science', 'Isaac Asimov', 4, 24.99, 20, 'https://covers.openlibrary.org/b/id/8232521-L.jpg', 'Ouvrage de vulgarisation scientifique', '2026-01-31 11:00:00'),
(627, 'Asimov\'s Science Fiction Magazine', 'Isaac Asimov', 4, 8.99, 50, 'https://covers.openlibrary.org/b/id/8232522-L.jpg', 'Revue de science-fiction fondée par Asimov', '2026-01-31 11:00:00'),
(628, 'La Fin de l\'éternité', 'Isaac Asimov', 4, 14.99, 32, 'https://covers.openlibrary.org/b/id/8232523-L.jpg', 'Roman sur les voyages dans le temps', '2026-01-31 11:00:00'),
(629, 'Les Dieux eux-mêmes', 'Isaac Asimov', 4, 15.25, 30, 'https://covers.openlibrary.org/b/id/8232524-L.jpg', 'Roman sur une source d\'énergie extraterrestre', '2026-01-31 11:00:00'),
(630, 'Nemesis', 'Isaac Asimov', 4, 16.50, 26, 'https://covers.openlibrary.org/b/id/8232525-L.jpg', 'Roman sur une étoile menaçant la Terre', '2026-01-31 11:00:00'),
(631, 'Le Secret des dieux', 'Isaac Asimov', 4, 13.75, 34, 'https://covers.openlibrary.org/b/id/8232526-L.jpg', 'Recueil de nouvelles de fantasy', '2026-01-31 11:00:00'),
(632, 'Toutes les nouvelles', 'Isaac Asimov', 4, 29.99, 18, 'https://covers.openlibrary.org/b/id/8232527-L.jpg', 'Intégrale des nouvelles de science-fiction', '2026-01-31 11:00:00'),
(633, 'Les Mondes de Fondation', 'Isaac Asimov', 4, 17.99, 24, 'https://covers.openlibrary.org/b/id/8232528-L.jpg', 'Atlas de l\'univers de Fondation', '2026-01-31 11:00:00'),
(634, 'La Science-fiction selon Asimov', 'Isaac Asimov', 4, 18.50, 22, 'https://covers.openlibrary.org/b/id/8232529-L.jpg', 'Essais sur le genre science-fiction', '2026-01-31 11:00:00'),
(635, 'Asimov: Les Robots - Intégrale', 'Isaac Asimov', 4, 22.99, 20, 'https://covers.openlibrary.org/b/id/8232530-L.jpg', 'Tous les romans des robots en un volume', '2026-01-31 11:00:00'),
(636, 'Asimov: L\'Empire - Intégrale', 'Isaac Asimov', 4, 21.50, 21, 'https://covers.openlibrary.org/b/id/8232531-L.jpg', 'Trilogie de l\'Empire en un volume', '2026-01-31 11:00:00'),
(637, 'Le Meilleur d\'Asimov', 'Isaac Asimov', 4, 19.99, 25, 'https://covers.openlibrary.org/b/id/8232532-L.jpg', 'Sélection des meilleures nouvelles', '2026-01-31 11:00:00'),
(638, 'Asimov: La Science expliquée', 'Isaac Asimov', 4, 23.75, 19, 'https://covers.openlibrary.org/b/id/8232533-L.jpg', 'Vulgarisation scientifique complète', '2026-01-31 11:00:00'),
(639, 'Dune - Le Messie de Dune', 'Frank Herbert', 4, 17.50, 28, 'https://covers.openlibrary.org/b/id/8232534-L.jpg', 'Deuxième tome du cycle de Dune', '2026-01-31 11:00:00'),
(640, 'Dune - Les Enfants de Dune', 'Frank Herbert', 4, 18.25, 26, 'https://covers.openlibrary.org/b/id/8232535-L.jpg', 'Troisième tome de Dune', '2026-01-31 11:00:00'),
(641, 'Dune - L\'Empereur-Dieu de Dune', 'Frank Herbert', 4, 19.50, 24, 'https://covers.openlibrary.org/b/id/8232536-L.jpg', 'Quatrième tome de Dune', '2026-01-31 11:00:00'),
(642, 'Dune - Les Hérétiques de Dune', 'Frank Herbert', 4, 20.75, 22, 'https://covers.openlibrary.org/b/id/8232537-L.jpg', 'Cinquième tome de Dune', '2026-01-31 11:00:00'),
(643, 'Dune - La Maison des Mères', 'Frank Herbert', 4, 21.99, 20, 'https://covers.openlibrary.org/b/id/8232538-L.jpg', 'Sixième et dernier tome de Dune', '2026-01-31 11:00:00'),
(644, 'Dune - Intégrale', 'Frank Herbert', 4, 49.99, 12, 'https://covers.openlibrary.org/b/id/8232539-L.jpg', 'Les six tomes en un volume', '2026-01-31 11:00:00'),
(645, 'Le Guide de Dune', 'Frank Herbert', 4, 22.50, 18, 'https://covers.openlibrary.org/b/id/8232540-L.jpg', 'Encyclopédie de l\'univers de Dune', '2026-01-31 11:00:00'),
(646, 'Dune - L\'Atlas', 'Frank Herbert', 4, 24.99, 15, 'https://covers.openlibrary.org/b/id/8232541-L.jpg', 'Cartes et géographie d\'Arrakis', '2026-01-31 11:00:00'),
(647, 'Dune - Les Chroniques', 'Frank Herbert', 4, 26.50, 14, 'https://covers.openlibrary.org/b/id/8232542-L.jpg', 'Histoire complète de l\'univers de Dune', '2026-01-31 11:00:00'),
(648, 'Dune - Le Jeu de rôle', 'Frank Herbert', 4, 29.99, 10, 'https://covers.openlibrary.org/b/id/8232543-L.jpg', 'Livre-règles pour jeu de rôle', '2026-01-31 11:00:00'),
(649, 'Dune - Édition illustrée', 'Frank Herbert', 4, 35.00, 8, 'https://covers.openlibrary.org/b/id/8232544-L.jpg', 'Édition de luxe avec illustrations', '2026-01-31 11:00:00'),
(650, 'Dune - Édition collector', 'Frank Herbert', 4, 59.99, 6, 'https://covers.openlibrary.org/b/id/8232545-L.jpg', 'Coffret numéroté avec artefacts', '2026-01-31 11:00:00'),
(651, 'Dune - Livre audio', 'Frank Herbert', 4, 32.50, 12, 'https://covers.openlibrary.org/b/id/8232546-L.jpg', 'Version audio complète', '2026-01-31 11:00:00'),
(652, 'Dune - Édition annotée', 'Frank Herbert', 4, 27.99, 16, 'https://covers.openlibrary.org/b/id/8232547-L.jpg', 'Édition critique avec commentaires', '2026-01-31 11:00:00'),
(653, 'Dune - Le Film', 'Frank Herbert', 4, 19.99, 24, 'https://covers.openlibrary.org/b/id/8232548-L.jpg', 'Adaptation cinématographique et making-of', '2026-01-31 11:00:00'),
(654, 'Dune - La Série TV', 'Frank Herbert', 4, 18.50, 26, 'https://covers.openlibrary.org/b/id/8232549-L.jpg', 'Adaptation télévisuelle et scénarios', '2026-01-31 11:00:00'),
(655, 'Dune - Les Préquelles', 'Brian Herbert', 4, 16.99, 30, 'https://covers.openlibrary.org/b/id/8232550-L.jpg', 'Prequelles écrites par le fils de Frank Herbert', '2026-01-31 11:00:00'),
(656, 'Dune - Les Suites', 'Brian Herbert', 4, 17.50, 28, 'https://covers.openlibrary.org/b/id/8232551-L.jpg', 'Suites écrites par Brian Herbert', '2026-01-31 11:00:00'),
(657, 'Dune - Le Dictionnaire', 'Frank Herbert', 4, 21.75, 20, 'https://covers.openlibrary.org/b/id/8232552-L.jpg', 'Lexique complet des termes de Dune', '2026-01-31 11:00:00'),
(658, 'Dune - La Philosophie', 'Frank Herbert', 4, 19.25, 22, 'https://covers.openlibrary.org/b/id/8232553-L.jpg', 'Analyse des concepts philosophiques de Dune', '2026-01-31 11:00:00'),
(659, 'Dune - L\'Écologie', 'Frank Herbert', 4, 18.99, 24, 'https://covers.openlibrary.org/b/id/8232554-L.jpg', 'Étude des systèmes écologiques d\'Arrakis', '2026-01-31 11:00:00'),
(660, 'Dune - La Politique', 'Frank Herbert', 4, 17.75, 26, 'https://covers.openlibrary.org/b/id/8232555-L.jpg', 'Analyse des systèmes politiques dans Dune', '2026-01-31 11:00:00'),
(661, 'Dune - La Religion', 'Frank Herbert', 4, 16.50, 30, 'https://covers.openlibrary.org/b/id/8232556-L.jpg', 'Étude des aspects religieux de Dune', '2026-01-31 11:00:00'),
(662, 'Dune - La Guerre', 'Frank Herbert', 4, 15.99, 32, 'https://covers.openlibrary.org/b/id/8232557-L.jpg', 'Analyse des stratégies militaires', '2026-01-31 11:00:00'),
(663, 'Dune - L\'Économie', 'Frank Herbert', 4, 14.75, 36, 'https://covers.openlibrary.org/b/id/8232558-L.jpg', 'Étude de l\'économie de l\'Épice', '2026-01-31 11:00:00'),
(664, 'Dune - La Société', 'Frank Herbert', 4, 13.50, 40, 'https://covers.openlibrary.org/b/id/8232559-L.jpg', 'Analyse des structures sociales', '2026-01-31 11:00:00'),
(665, 'Dune - La Culture', 'Frank Herbert', 4, 12.99, 42, 'https://covers.openlibrary.org/b/id/8232560-L.jpg', 'Étude des cultures dans l\'univers de Dune', '2026-01-31 11:00:00'),
(666, 'Dune - La Science', 'Frank Herbert', 4, 11.75, 46, 'https://covers.openlibrary.org/b/id/8232561-L.jpg', 'Analyse des aspects scientifiques', '2026-01-31 11:00:00'),
(667, 'Dune - La Technologie', 'Frank Herbert', 4, 10.50, 50, 'https://covers.openlibrary.org/b/id/8232562-L.jpg', 'Étude des technologies dans Dune', '2026-01-31 11:00:00'),
(668, 'Dune - L\'Art', 'Frank Herbert', 4, 9.99, 55, 'https://covers.openlibrary.org/b/id/8232563-L.jpg', 'Recueil d\'illustrations et d\'art conceptuel', '2026-01-31 11:00:00'),
(669, 'Dune - La Musique', 'Frank Herbert', 4, 8.75, 60, 'https://covers.openlibrary.org/b/id/8232564-L.jpg', 'Partitions et analyse musicale', '2026-01-31 11:00:00'),
(670, 'Dune - Le Cinéma', 'Frank Herbert', 4, 7.50, 65, 'https://covers.openlibrary.org/b/id/8232565-L.jpg', 'Histoire des adaptations cinématographiques', '2026-01-31 11:00:00'),
(671, 'Dune - La BD', 'Frank Herbert', 4, 6.99, 70, 'https://covers.openlibrary.org/b/id/8232566-L.jpg', 'Adaptation en bande dessinée', '2026-01-31 11:00:00'),
(672, 'Dune - Le Jeu vidéo', 'Frank Herbert', 4, 5.99, 75, 'https://covers.openlibrary.org/b/id/8232567-L.jpg', 'Guide des jeux vidéo inspirés de Dune', '2026-01-31 11:00:00'),
(673, 'Dune - Les Jouets', 'Frank Herbert', 4, 4.99, 80, 'https://covers.openlibrary.org/b/id/8232568-L.jpg', 'Catalogue des produits dérivés', '2026-01-31 11:00:00'),
(674, 'Les Mémoires de guerre - Tome 1', 'Charles de Gaulle', 5, 22.50, 18, 'https://covers.openlibrary.org/b/id/8232569-L.jpg', 'Premier tome des mémoires du général de Gaulle', '2026-01-31 12:00:00'),
(675, 'Les Mémoires de guerre - Tome 2', 'Charles de Gaulle', 5, 23.75, 16, 'https://covers.openlibrary.org/b/id/8232570-L.jpg', 'Deuxième tome sur la Libération', '2026-01-31 12:00:00'),
(676, 'Les Mémoires de guerre - Tome 3', 'Charles de Gaulle', 5, 24.99, 14, 'https://covers.openlibrary.org/b/id/8232571-L.jpg', 'Dernier tome sur l\'après-guerre', '2026-01-31 12:00:00'),
(677, 'Les Mémoires d\'espoir - Tome 1', 'Charles de Gaulle', 5, 21.50, 20, 'https://covers.openlibrary.org/b/id/8232572-L.jpg', 'Mémoires sur la présidence de la République', '2026-01-31 12:00:00'),
(678, 'Les Mémoires d\'espoir - Tome 2', 'Charles de Gaulle', 5, 22.99, 18, 'https://covers.openlibrary.org/b/id/8232573-L.jpg', 'Suite des mémoires présidentielles', '2026-01-31 12:00:00'),
(679, 'Le Fil de l\'épée', 'Charles de Gaulle', 5, 18.75, 25, 'https://covers.openlibrary.org/b/id/8232574-L.jpg', 'Premier essai sur le leadership militaire', '2026-01-31 12:00:00'),
(680, 'Vers l\'armée de métier', 'Charles de Gaulle', 5, 17.50, 28, 'https://covers.openlibrary.org/b/id/8232575-L.jpg', 'Projet de réforme de l\'armée française', '2026-01-31 12:00:00'),
(681, 'La France et son armée', 'Charles de Gaulle', 5, 19.99, 22, 'https://covers.openlibrary.org/b/id/8232576-L.jpg', 'Histoire militaire de la France', '2026-01-31 12:00:00'),
(682, 'Trois études', 'Charles de Gaulle', 5, 16.25, 32, 'https://covers.openlibrary.org/b/id/8232577-L.jpg', 'Recueil d\'études historiques', '2026-01-31 12:00:00'),
(683, 'Mémoires de ma vie', 'Charles de Gaulle', 5, 20.50, 24, 'https://covers.openlibrary.org/b/id/8232578-L.jpg', 'Autobiographie inachevée', '2026-01-31 12:00:00'),
(684, 'Lettres, notes et carnets', 'Charles de Gaulle', 5, 35.99, 12, 'https://covers.openlibrary.org/b/id/8232579-L.jpg', 'Correspondance et notes personnelles', '2026-01-31 12:00:00'),
(685, 'Discours et messages', 'Charles de Gaulle', 5, 28.50, 15, 'https://covers.openlibrary.org/b/id/8232580-L.jpg', 'Recueil des principaux discours', '2026-01-31 12:00:00'),
(686, 'Le Salut', 'Charles de Gaulle', 5, 21.75, 20, 'https://covers.openlibrary.org/b/id/8232581-L.jpg', 'Dernier volume des mémoires de guerre', '2026-01-31 12:00:00'),
(687, 'L\'Unité', 'Charles de Gaulle', 5, 20.99, 22, 'https://covers.openlibrary.org/b/id/8232582-L.jpg', 'Deuxième volume des mémoires de guerre', '2026-01-31 12:00:00'),
(688, 'L\'Appel', 'Charles de Gaulle', 5, 19.50, 25, 'https://covers.openlibrary.org/b/id/8232583-L.jpg', 'Premier volume des mémoires de guerre', '2026-01-31 12:00:00'),
(689, 'Le Renouveau', 'Charles de Gaulle', 5, 22.25, 18, 'https://covers.openlibrary.org/b/id/8232584-L.jpg', 'Premier volume des mémoires d\'espoir', '2026-01-31 12:00:00'),
(690, 'L\'Effort', 'Charles de Gaulle', 5, 23.50, 16, 'https://covers.openlibrary.org/b/id/8232585-L.jpg', 'Deuxième volume des mémoires d\'espoir', '2026-01-31 12:00:00'),
(691, 'La Statue intérieure', 'François Mauriac', 5, 17.99, 26, 'https://covers.openlibrary.org/b/id/8232586-L.jpg', 'Biographie intellectuelle de de Gaulle', '2026-01-31 12:00:00'),
(692, 'De Gaulle', 'Jean Lacouture', 5, 29.99, 14, 'https://covers.openlibrary.org/b/id/8232587-L.jpg', 'Biographie monumentale en trois volumes', '2026-01-31 12:00:00'),
(693, 'Le Général', 'Paul-Marie de La Gorce', 5, 24.50, 18, 'https://covers.openlibrary.org/b/id/8232588-L.jpg', 'Biographie politique de de Gaulle', '2026-01-31 12:00:00'),
(694, 'De Gaulle - Tome 1', 'Max Gallo', 5, 21.99, 22, 'https://covers.openlibrary.org/b/id/8232589-L.jpg', 'Premier tome de la biographie par Max Gallo', '2026-01-31 12:00:00'),
(695, 'De Gaulle - Tome 2', 'Max Gallo', 5, 22.50, 20, 'https://covers.openlibrary.org/b/id/8232590-L.jpg', 'Deuxième tome de la biographie', '2026-01-31 12:00:00'),
(696, 'De Gaulle - Tome 3', 'Max Gallo', 5, 23.25, 18, 'https://covers.openlibrary.org/b/id/8232591-L.jpg', 'Dernier tome de la biographie', '2026-01-31 12:00:00'),
(697, 'De Gaulle - Tome 4', 'Max Gallo', 5, 24.99, 16, 'https://covers.openlibrary.org/b/id/8232592-L.jpg', 'Quatrième tome complémentaire', '2026-01-31 12:00:00'),
(698, 'Le Siècle de de Gaulle', 'Collectif', 5, 26.50, 15, 'https://covers.openlibrary.org/b/id/8232593-L.jpg', 'Ouvrage collectif sur l\'héritage gaulliste', '2026-01-31 12:00:00'),
(699, 'De Gaulle et les Français', 'Jean-François Sirinelli', 5, 20.75, 24, 'https://covers.openlibrary.org/b/id/8232594-L.jpg', 'Étude des relations avec l\'opinion publique', '2026-01-31 12:00:00'),
(700, 'De Gaulle et l\'Algérie', 'Benjamin Stora', 5, 19.99, 26, 'https://covers.openlibrary.org/b/id/8232595-L.jpg', 'Analyse de la politique algérienne', '2026-01-31 12:00:00'),
(701, 'De Gaulle et l\'Europe', 'Élisabeth du Réau', 5, 18.50, 28, 'https://covers.openlibrary.org/b/id/8232596-L.jpg', 'Étude de la politique européenne', '2026-01-31 12:00:00'),
(702, 'De Gaulle et les États-Unis', 'Charles Cogan', 5, 17.25, 32, 'https://covers.openlibrary.org/b/id/8232597-L.jpg', 'Analyse des relations transatlantiques', '2026-01-31 12:00:00'),
(703, 'De Gaulle et l\'URSS', 'Marie-Pierre Rey', 5, 16.99, 34, 'https://covers.openlibrary.org/b/id/8232598-L.jpg', 'Étude des relations avec l\'Union soviétique', '2026-01-31 12:00:00'),
(704, 'De Gaulle et la Chine', 'François Joyaux', 5, 15.75, 36, 'https://covers.openlibrary.org/b/id/8232599-L.jpg', 'Analyse des relations sino-françaises', '2026-01-31 12:00:00'),
(705, 'De Gaulle et l\'Afrique', 'Jacques Frémeaux', 5, 14.50, 40, 'https://covers.openlibrary.org/b/id/8232600-L.jpg', 'Étude de la politique africaine', '2026-01-31 12:00:00'),
(706, 'De Gaulle et le Moyen-Orient', 'Laurence Nardon', 5, 13.25, 44, 'https://covers.openlibrary.org/b/id/8232601-L.jpg', 'Analyse de la politique moyen-orientale', '2026-01-31 12:00:00'),
(707, 'De Gaulle et l\'économie', 'Éric Roussel', 5, 12.99, 46, 'https://covers.openlibrary.org/b/id/8232602-L.jpg', 'Étude de la politique économique', '2026-01-31 12:00:00'),
(708, 'De Gaulle et la culture', 'Claire Blandin', 5, 11.75, 50, 'https://covers.openlibrary.org/b/id/8232603-L.jpg', 'Analyse de la politique culturelle', '2026-01-31 12:00:00'),
(709, 'De Gaulle et l\'éducation', 'Antoine Prost', 5, 10.50, 54, 'https://covers.openlibrary.org/b/id/8232604-L.jpg', 'Étude des réformes éducatives', '2026-01-31 12:00:00'),
(710, 'De Gaulle et la justice', 'Denis Salas', 5, 9.99, 58, 'https://covers.openlibrary.org/b/id/8232605-L.jpg', 'Analyse des réformes judiciaires', '2026-01-31 12:00:00'),
(711, 'De Gaulle et la santé', 'Didier Tabuteau', 5, 8.75, 62, 'https://covers.openlibrary.org/b/id/8232606-L.jpg', 'Étude de la politique de santé', '2026-01-31 12:00:00'),
(712, 'De Gaulle et les transports', 'Patrice Salini', 5, 7.50, 66, 'https://covers.openlibrary.org/b/id/8232607-L.jpg', 'Analyse des infrastructures de transport', '2026-01-31 12:00:00'),
(713, 'De Gaulle et l\'urbanisme', 'Thierry Paquot', 5, 6.99, 70, 'https://covers.openlibrary.org/b/id/8232608-L.jpg', 'Étude de l\'aménagement du territoire', '2026-01-31 12:00:00'),
(714, 'De Gaulle et l\'environnement', 'Jean-Jacques Delannoy', 5, 5.99, 74, 'https://covers.openlibrary.org/b/id/8232609-L.jpg', 'Analyse de la politique environnementale', '2026-01-31 12:00:00'),
(715, 'De Gaulle et la recherche', 'Pierre Papon', 5, 4.99, 78, 'https://covers.openlibrary.org/b/id/8232610-L.jpg', 'Étude de la politique scientifique', '2026-01-31 12:00:00'),
(716, 'De Gaulle et la défense', 'Maurice Vaïsse', 5, 3.99, 82, 'https://covers.openlibrary.org/b/id/8232611-L.jpg', 'Analyse de la politique de défense', '2026-01-31 12:00:00'),
(717, 'De Gaulle et la diplomatie', 'Georges-Henri Soutou', 5, 2.99, 86, 'https://covers.openlibrary.org/b/id/8232612-L.jpg', 'Étude de la politique étrangère', '2026-01-31 12:00:00'),
(718, 'De Gaulle et les médias', 'Évelyne Cohen', 5, 1.99, 90, 'https://covers.openlibrary.org/b/id/8232613-L.jpg', 'Analyse des relations avec la presse', '2026-01-31 12:00:00'),
(719, 'De Gaulle et la télévision', 'Jérôme Bourdon', 5, 0.99, 95, 'https://covers.openlibrary.org/b/id/8232614-L.jpg', 'Étude de l\'utilisation de la télévision', '2026-01-31 12:00:00');

-- --------------------------------------------------------

--
-- Structure de la table `cart`
--

CREATE TABLE `cart` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `book_id` int(11) NOT NULL,
  `quantity` int(11) DEFAULT 1,
  `added_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `cart`
--

INSERT INTO `cart` (`id`, `user_id`, `book_id`, `quantity`, `added_at`) VALUES
(37, 1, 1, 1, '2026-01-28 16:13:48'),
(38, 1, 5, 2, '2026-01-28 16:13:48'),
(39, 2, 3, 1, '2026-01-28 16:13:48'),
(40, 3, 4, 3, '2026-01-28 16:13:48'),
(53, 5, 2, 1, '2026-01-28 17:16:09'),
(81, 7, 51, 1, '2026-02-02 09:47:16'),
(82, 7, 2, 1, '2026-02-02 09:52:30'),
(83, 7, 3, 2, '2026-02-02 10:27:45');

-- --------------------------------------------------------

--
-- Structure de la table `categories`
--

CREATE TABLE `categories` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `categories`
--

INSERT INTO `categories` (`id`, `name`, `description`) VALUES
(1, 'Romans', 'Livres de fiction et histoires romanesques'),
(2, 'Essais', 'Ouvrages analytiques et réflexifs'),
(3, 'Jeunesse', 'Livres pour enfants et jeunes adultes'),
(4, 'Science-Fiction', 'Univers futuristes et imaginaires'),
(5, 'Historique', 'Récits et analyses historiques');

-- --------------------------------------------------------

--
-- Structure de la table `ratings`
--

CREATE TABLE `ratings` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `book_id` int(11) NOT NULL,
  `rating` int(11) DEFAULT NULL CHECK (`rating` >= 1 and `rating` <= 5),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `ratings`
--

INSERT INTO `ratings` (`id`, `user_id`, `book_id`, `rating`, `created_at`, `updated_at`) VALUES
(12, 1, 1, 5, '2026-01-28 16:06:23', '2026-01-29 22:42:37'),
(13, 1, 2, 4, '2026-01-28 16:06:23', '2026-01-29 22:42:37'),
(14, 1, 3, 3, '2026-01-28 16:06:23', '2026-01-29 22:42:37'),
(15, 2, 4, 5, '2026-01-28 16:06:23', '2026-01-29 22:42:37'),
(16, 2, 5, 4, '2026-01-28 16:06:23', '2026-01-29 22:42:37'),
(17, 2, 1, 4, '2026-01-28 16:06:23', '2026-01-29 22:42:37'),
(18, 3, 2, 5, '2026-01-28 16:06:23', '2026-01-29 22:42:37'),
(19, 3, 3, 5, '2026-01-28 16:06:23', '2026-01-29 22:42:37'),
(20, 3, 4, 3, '2026-01-28 16:06:23', '2026-01-29 22:42:37'),
(81, 5, 12, 5, '2026-01-28 17:14:13', '2026-01-30 00:18:08'),
(82, 5, 13, 5, '2026-01-28 17:14:23', '2026-01-30 00:18:08'),
(84, 5, 2, 4, '2026-01-28 17:16:37', '2026-01-29 22:42:37'),
(85, 5, 1, 4, '2026-01-28 17:16:40', '2026-01-29 22:42:37'),
(86, 6, 6, 4, '2026-01-28 19:21:47', '2026-01-29 23:18:01'),
(87, 6, 2, 4, '2026-01-29 11:16:18', '2026-01-29 22:42:37'),
(88, 6, 8, 5, '2026-01-29 11:16:27', '2026-01-29 22:42:37'),
(89, 6, 3, 3, '2026-01-29 11:52:15', '2026-01-29 23:13:16'),
(90, 6, 12, 3, '2026-01-29 12:27:39', '2026-01-30 00:18:08'),
(91, 6, 5, 5, '2026-01-29 22:45:42', '2026-01-29 23:12:29'),
(92, 6, 7, 3, '2026-01-29 22:45:45', '2026-01-29 22:45:45'),
(93, 6, 10, 3, '2026-01-29 22:45:53', '2026-01-29 23:10:28'),
(95, 6, 9, 2, '2026-01-29 23:08:36', '2026-01-29 23:08:36'),
(96, 6, 11, 3, '2026-01-29 23:08:43', '2026-01-30 00:18:08'),
(98, 6, 70, 1, '2026-01-29 23:22:45', '2026-01-29 23:22:45'),
(99, 6, 69, 5, '2026-01-29 23:22:48', '2026-01-29 23:26:39'),
(102, 6, 4, 5, '2026-01-29 23:26:29', '2026-01-29 23:26:29'),
(105, 6, 66, 4, '2026-01-29 23:26:44', '2026-01-29 23:26:44'),
(107, 7, 1, 1, '2026-01-30 13:28:17', '2026-02-02 09:47:30'),
(109, 7, 2, 1, '2026-01-30 13:28:19', '2026-01-30 15:00:51'),
(111, 7, 3, 5, '2026-01-30 13:28:22', '2026-02-02 09:48:23'),
(113, 7, 62, 1, '2026-01-30 13:28:52', '2026-01-30 14:23:28'),
(115, 7, 60, 2, '2026-01-30 13:28:59', '2026-01-30 13:28:59'),
(117, 7, 65, 1, '2026-01-30 14:22:04', '2026-01-30 14:23:33'),
(118, 7, 4, 4, '2026-01-30 14:22:31', '2026-02-02 09:47:34'),
(119, 7, 8, 5, '2026-01-30 14:22:33', '2026-01-30 14:49:14'),
(120, 7, 11, 1, '2026-01-30 14:22:53', '2026-01-30 14:30:41'),
(121, 7, 6, 1, '2026-01-30 14:30:23', '2026-02-02 09:47:41'),
(122, 7, 7, 5, '2026-01-30 14:49:12', '2026-02-02 09:47:39'),
(123, 7, 53, 5, '2026-01-30 14:49:25', '2026-01-30 14:49:25');

-- --------------------------------------------------------

--
-- Structure de la table `recommendation_stats`
--

CREATE TABLE `recommendation_stats` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `total_recommendations` int(11) DEFAULT 0,
  `total_clicks` int(11) DEFAULT 0,
  `click_rate` decimal(5,2) DEFAULT 0.00,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `recommendation_stats`
--

INSERT INTO `recommendation_stats` (`id`, `user_id`, `total_recommendations`, `total_clicks`, `click_rate`, `last_updated`) VALUES
(1, 6, 1, 1, 0.00, '2026-01-29 23:26:17'),
(2, 6, 1, 1, 0.00, '2026-01-29 23:26:29'),
(3, 6, 1, 1, 0.00, '2026-01-29 23:26:39'),
(4, 6, 1, 1, 0.00, '2026-01-29 23:26:44'),
(5, 7, 1, 1, 0.00, '2026-01-30 13:28:17'),
(6, 7, 1, 1, 0.00, '2026-01-30 13:28:19'),
(7, 7, 1, 1, 0.00, '2026-01-30 13:28:22'),
(8, 7, 1, 1, 0.00, '2026-01-30 13:28:52'),
(9, 7, 1, 1, 0.00, '2026-01-30 13:28:59'),
(10, 7, 1, 1, 0.00, '2026-01-30 14:21:48'),
(11, 7, 1, 1, 0.00, '2026-01-30 14:21:50'),
(12, 7, 1, 1, 0.00, '2026-01-30 14:22:04'),
(13, 7, 1, 1, 0.00, '2026-01-30 14:22:27'),
(14, 7, 1, 1, 0.00, '2026-01-30 14:22:29'),
(15, 7, 1, 1, 0.00, '2026-01-30 14:22:31'),
(16, 7, 1, 1, 0.00, '2026-01-30 14:22:33'),
(17, 7, 1, 1, 0.00, '2026-01-30 14:22:53'),
(18, 7, 1, 1, 0.00, '2026-01-30 14:23:06'),
(19, 7, 1, 1, 0.00, '2026-01-30 14:23:11'),
(20, 7, 1, 1, 0.00, '2026-01-30 14:23:28'),
(21, 7, 1, 1, 0.00, '2026-01-30 14:23:33'),
(22, 7, 1, 1, 0.00, '2026-01-30 14:30:15'),
(23, 7, 1, 1, 0.00, '2026-01-30 14:30:18'),
(24, 7, 1, 1, 0.00, '2026-01-30 14:30:23'),
(25, 7, 1, 1, 0.00, '2026-01-30 14:30:41'),
(26, 7, 1, 1, 0.00, '2026-01-30 14:49:10'),
(27, 7, 1, 1, 0.00, '2026-01-30 14:49:12'),
(28, 7, 1, 1, 0.00, '2026-01-30 14:49:14'),
(29, 7, 1, 1, 0.00, '2026-01-30 14:49:25'),
(30, 7, 1, 1, 0.00, '2026-01-30 15:00:51'),
(31, 7, 1, 1, 0.00, '2026-01-30 15:00:54'),
(32, 7, 1, 1, 0.00, '2026-01-30 15:00:58'),
(33, 7, 1, 1, 0.00, '2026-02-02 09:47:30'),
(34, 7, 1, 1, 0.00, '2026-02-02 09:47:34'),
(35, 7, 1, 1, 0.00, '2026-02-02 09:47:39'),
(36, 7, 1, 1, 0.00, '2026-02-02 09:47:41'),
(37, 7, 1, 1, 0.00, '2026-02-02 09:48:23');

-- --------------------------------------------------------

--
-- Structure de la table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `email` varchar(120) NOT NULL,
  `password` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `users`
--

INSERT INTO `users` (`id`, `username`, `email`, `password`, `created_at`) VALUES
(1, 'nouveau_user2', 'email@example2.com', '123456', '2026-01-28 16:01:47'),
(2, 'test_user2', 'user2@example.com', 'hashed_password2', '2026-01-28 16:06:23'),
(3, 'test_user3', 'user3@example.com', 'hashed_password3', '2026-01-28 16:06:23'),
(5, 'wissal2', 'wissal@gmail.com', '$2a$10$J0VGWjCXEkBvq6ncYOIP0uxXqpXSZ1llmtp2pjfWbIjUtPmXcy6zC', '2026-01-28 17:10:31'),
(6, 'test3', 'tester@gmail.com', '$2a$10$T44OR/AZI/zmaG4gq8xKFuCqmz4PeHO0.7xyeggoi2JgsTo3Gxla.', '2026-01-28 19:20:18'),
(7, 'ikhlass', 'ikhlass@gmail.com', '$2a$10$6oyOtoRNHtySEtL/JpMsoOcsW4sepTTcmdgQcfZJRuekAcqtWAEAi', '2026-01-30 13:27:48');

-- --------------------------------------------------------

--
-- Structure de la table `user_preferences`
--

CREATE TABLE `user_preferences` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `category_id` int(11) NOT NULL,
  `preference_score` float DEFAULT 0,
  `rating_count` int(11) DEFAULT 0,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `user_preferences`
--

INSERT INTO `user_preferences` (`id`, `user_id`, `category_id`, `preference_score`, `rating_count`, `last_updated`, `created_at`) VALUES
(1, 6, 1, 222, 66, '2026-01-30 13:27:02', '2026-01-29 22:45:42'),
(2, 6, 5, 24, 8, '2026-01-30 13:27:02', '2026-01-29 22:45:45'),
(5, 6, 4, 77, 22, '2026-01-30 13:27:02', '2026-01-29 23:08:21'),
(10, 6, 3, 35, 7, '2026-01-30 13:27:02', '2026-01-29 23:08:21'),
(62, 6, 2, 16, 4, '2026-01-30 13:27:02', '2026-01-29 23:26:44'),
(108, 7, 3, 209, 79, '2026-02-02 10:57:27', '2026-01-30 13:28:17'),
(109, 7, 4, 167, 76, '2026-02-02 10:57:27', '2026-01-30 13:28:19'),
(110, 7, 1, 185, 86, '2026-02-02 10:57:27', '2026-01-30 13:28:22'),
(128, 7, 2, 40, 24, '2026-02-02 10:57:27', '2026-01-30 14:22:04'),
(243, 7, 5, 38, 13, '2026-02-02 10:57:27', '2026-01-30 14:49:12');

-- --------------------------------------------------------

--
-- Structure de la table `user_preferred_authors`
--

CREATE TABLE `user_preferred_authors` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `author_name` varchar(255) NOT NULL,
  `preference_score` float DEFAULT 0,
  `rating_count` int(11) DEFAULT 0,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `user_preferred_authors`
--

INSERT INTO `user_preferred_authors` (`id`, `user_id`, `author_name`, `preference_score`, `rating_count`, `last_updated`, `created_at`) VALUES
(1, 6, 'Jane Austen', 37, 9, '2026-01-30 13:27:02', '2026-01-29 22:45:42'),
(2, 6, 'Jean-Claude Damamme', 24, 8, '2026-01-30 13:27:02', '2026-01-29 22:45:45'),
(3, 6, 'Paulo Coelho', 35, 9, '2026-01-30 13:27:02', '2026-01-29 22:45:53'),
(4, 6, 'Fiodor Dostoïevski', 44, 18, '2026-01-30 13:27:02', '2026-01-29 22:46:22'),
(5, 6, 'George Orwell', 28, 7, '2026-01-30 13:27:02', '2026-01-29 23:08:21'),
(6, 6, 'Voltaire', 30, 8, '2026-01-30 13:27:02', '2026-01-29 23:08:21'),
(8, 6, 'Isaac Asimov', 35, 8, '2026-01-30 13:27:02', '2026-01-29 23:08:21'),
(10, 6, 'J.K. Rowling', 35, 7, '2026-01-30 13:27:02', '2026-01-29 23:08:21'),
(14, 6, 'Frank Herbert', 14, 7, '2026-01-30 13:27:02', '2026-01-29 23:08:36'),
(15, 6, 'Franz Kafka', 30, 8, '2026-01-30 13:27:02', '2026-01-29 23:08:43'),
(44, 6, 'Mary Shelley', 5, 5, '2026-01-30 13:27:02', '2026-01-29 23:22:45'),
(57, 6, 'Bram Stoker', 21, 5, '2026-01-30 13:27:02', '2026-01-29 23:26:05'),
(60, 6, 'Victor Hugo', 20, 4, '2026-01-30 13:27:02', '2026-01-29 23:26:29'),
(62, 6, 'Sun Tzu', 16, 4, '2026-01-30 13:27:02', '2026-01-29 23:26:44'),
(108, 7, 'Antoine de Saint-Exupéry', 75, 29, '2026-02-02 10:57:27', '2026-01-30 13:28:17'),
(109, 7, 'George Orwell', 113, 56, '2026-02-02 10:57:27', '2026-01-30 13:28:19'),
(110, 7, 'Voltaire', 50, 28, '2026-02-02 10:57:27', '2026-01-30 13:28:22'),
(114, 7, 'Lewis Carroll', 50, 26, '2026-02-02 10:57:27', '2026-01-30 13:28:52'),
(128, 7, 'Yuval Noah Harari', 40, 24, '2026-02-02 10:57:27', '2026-01-30 14:22:04'),
(137, 7, 'Victor Hugo', 48, 24, '2026-02-02 10:57:27', '2026-01-30 14:22:31'),
(138, 7, 'J.K. Rowling', 84, 24, '2026-02-02 10:57:27', '2026-01-30 14:22:34'),
(147, 7, 'Franz Kafka', 27, 22, '2026-02-02 10:57:27', '2026-01-30 14:22:53'),
(190, 7, 'Isaac Asimov', 54, 20, '2026-02-02 10:57:27', '2026-01-30 14:30:23'),
(243, 7, 'Jean-Claude Damamme', 38, 13, '2026-02-02 10:57:27', '2026-01-30 14:49:12'),
(245, 7, 'Alexandre Dumas', 60, 12, '2026-02-02 10:57:27', '2026-01-30 14:49:25');

-- --------------------------------------------------------

--
-- Structure de la table `user_recommendations`
--

CREATE TABLE `user_recommendations` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `book_id` int(11) NOT NULL,
  `recommended_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `clicked` tinyint(4) DEFAULT 0,
  `clicked_at` timestamp NULL DEFAULT NULL,
  `interaction_type` enum('view','cart','rating','purchase') DEFAULT 'view',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `last_interaction` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `user_recommendations`
--

INSERT INTO `user_recommendations` (`id`, `user_id`, `book_id`, `recommended_at`, `clicked`, `clicked_at`, `interaction_type`, `created_at`, `last_interaction`) VALUES
(1, 6, 8, '2026-01-29 11:05:09', 0, NULL, 'cart', '2026-01-29 11:05:09', '2026-01-29 11:05:09'),
(2, 6, 8, '2026-01-29 11:05:09', 0, NULL, 'cart', '2026-01-29 11:05:09', '2026-01-29 11:05:09'),
(3, 6, 3, '2026-01-29 11:05:13', 0, NULL, 'view', '2026-01-29 11:05:13', '2026-01-29 11:05:13'),
(4, 6, 2, '2026-01-29 11:05:19', 0, NULL, 'view', '2026-01-29 11:05:19', '2026-01-29 11:05:19'),
(5, 6, 14, '2026-01-29 11:05:21', 0, NULL, 'view', '2026-01-29 11:05:21', '2026-01-30 00:18:47'),
(6, 6, 14, '2026-01-29 11:05:22', 0, NULL, 'view', '2026-01-29 11:05:22', '2026-01-30 00:18:47'),
(7, 6, 14, '2026-01-29 11:05:24', 0, NULL, 'view', '2026-01-29 11:05:24', '2026-01-30 00:18:47'),
(8, 6, 2, '2026-01-29 11:12:34', 0, NULL, 'cart', '2026-01-29 11:12:34', '2026-01-29 11:12:34'),
(9, 6, 2, '2026-01-29 11:12:34', 0, NULL, 'cart', '2026-01-29 11:12:34', '2026-01-29 11:12:34'),
(10, 6, 3, '2026-01-29 11:12:36', 0, NULL, 'cart', '2026-01-29 11:12:36', '2026-01-29 11:12:36'),
(11, 6, 3, '2026-01-29 11:12:36', 0, NULL, 'cart', '2026-01-29 11:12:36', '2026-01-29 11:12:36'),
(12, 6, 12, '2026-01-29 11:12:40', 0, NULL, 'cart', '2026-01-29 11:12:40', '2026-01-30 00:18:47'),
(13, 6, 12, '2026-01-29 11:12:40', 0, NULL, 'cart', '2026-01-29 11:12:40', '2026-01-30 00:18:47'),
(14, 6, 11, '2026-01-29 11:12:42', 0, NULL, 'cart', '2026-01-29 11:12:42', '2026-01-30 00:18:47'),
(15, 6, 11, '2026-01-29 11:12:42', 0, NULL, 'cart', '2026-01-29 11:12:42', '2026-01-30 00:18:47'),
(16, 6, 11, '2026-01-29 11:12:44', 0, NULL, 'view', '2026-01-29 11:12:44', '2026-01-30 00:18:47'),
(17, 6, 15, '2026-01-29 11:13:22', 0, NULL, 'cart', '2026-01-29 11:13:22', '2026-01-30 00:18:47'),
(18, 6, 15, '2026-01-29 11:13:22', 0, NULL, 'cart', '2026-01-29 11:13:22', '2026-01-30 00:18:47'),
(19, 6, 15, '2026-01-29 11:13:24', 0, NULL, 'view', '2026-01-29 11:13:24', '2026-01-30 00:18:47'),
(20, 6, 15, '2026-01-29 11:13:37', 0, NULL, 'view', '2026-01-29 11:13:37', '2026-01-30 00:18:47'),
(21, 6, 14, '2026-01-29 11:13:42', 0, NULL, 'view', '2026-01-29 11:13:42', '2026-01-30 00:18:47'),
(22, 6, 13, '2026-01-29 11:13:48', 0, NULL, 'view', '2026-01-29 11:13:48', '2026-01-30 00:18:47'),
(23, 6, 15, '2026-01-29 11:15:48', 0, NULL, 'view', '2026-01-29 11:15:48', '2026-01-30 00:18:47'),
(24, 6, 14, '2026-01-29 11:15:52', 0, NULL, 'view', '2026-01-29 11:15:52', '2026-01-30 00:18:47'),
(25, 6, 2, '2026-01-29 11:16:18', 0, NULL, 'rating', '2026-01-29 11:16:18', '2026-01-29 11:16:18'),
(26, 6, 8, '2026-01-29 11:16:27', 0, NULL, 'rating', '2026-01-29 11:16:27', '2026-01-29 11:16:27'),
(27, 6, 9, '2026-01-29 11:16:42', 0, NULL, 'view', '2026-01-29 11:16:42', '2026-01-29 11:16:42'),
(28, 6, 13, '2026-01-29 11:16:46', 0, NULL, 'view', '2026-01-29 11:16:46', '2026-01-30 00:18:47'),
(29, 6, 15, '2026-01-29 11:17:18', 0, NULL, 'view', '2026-01-29 11:17:18', '2026-01-30 00:18:47'),
(30, 6, 3, '2026-01-29 11:52:15', 0, NULL, 'rating', '2026-01-29 11:52:15', '2026-01-29 11:52:15'),
(31, 6, 6, '2026-01-29 11:52:21', 0, NULL, 'cart', '2026-01-29 11:52:21', '2026-01-29 11:52:21'),
(32, 6, 6, '2026-01-29 11:52:22', 0, NULL, 'cart', '2026-01-29 11:52:22', '2026-01-29 11:52:22'),
(33, 6, 5, '2026-01-29 11:52:24', 0, NULL, 'cart', '2026-01-29 11:52:24', '2026-01-29 11:52:24'),
(34, 6, 5, '2026-01-29 11:52:24', 0, NULL, 'cart', '2026-01-29 11:52:24', '2026-01-29 11:52:24'),
(35, 6, 5, '2026-01-29 11:52:25', 0, NULL, 'view', '2026-01-29 11:52:25', '2026-01-29 11:52:25'),
(36, 6, 8, '2026-01-29 11:52:32', 0, NULL, 'view', '2026-01-29 11:52:32', '2026-01-29 11:52:32'),
(37, 6, 10, '2026-01-29 11:52:39', 0, NULL, 'view', '2026-01-29 11:52:39', '2026-01-29 11:52:39'),
(38, 6, 12, '2026-01-29 12:27:39', 0, NULL, 'rating', '2026-01-29 12:27:39', '2026-01-30 00:18:47'),
(39, 6, 5, '2026-01-29 22:45:43', 1, NULL, 'rating', '2026-01-29 22:45:43', '2026-01-29 22:45:43'),
(40, 6, 5, '2026-01-29 22:45:43', 1, NULL, 'rating', '2026-01-29 22:45:43', '2026-01-29 22:45:43'),
(41, 6, 7, '2026-01-29 22:45:46', 1, NULL, 'rating', '2026-01-29 22:45:46', '2026-01-29 22:45:46'),
(42, 6, 7, '2026-01-29 22:45:46', 1, NULL, 'rating', '2026-01-29 22:45:46', '2026-01-29 22:45:46'),
(43, 6, 7, '2026-01-29 22:45:48', 0, NULL, 'cart', '2026-01-29 22:45:48', '2026-01-29 22:45:48'),
(44, 6, 7, '2026-01-29 22:45:48', 0, NULL, 'cart', '2026-01-29 22:45:48', '2026-01-29 22:45:48'),
(45, 6, 10, '2026-01-29 22:45:52', 0, NULL, 'cart', '2026-01-29 22:45:52', '2026-01-29 22:45:52'),
(46, 6, 10, '2026-01-29 22:45:52', 0, NULL, 'cart', '2026-01-29 22:45:52', '2026-01-29 22:45:52'),
(47, 6, 10, '2026-01-29 22:45:54', 1, NULL, 'rating', '2026-01-29 22:45:54', '2026-01-29 22:45:54'),
(48, 6, 10, '2026-01-29 22:45:54', 1, NULL, 'rating', '2026-01-29 22:45:54', '2026-01-29 22:45:54'),
(49, 6, 12, '2026-01-29 22:46:20', 0, NULL, 'view', '2026-01-29 22:46:20', '2026-01-30 00:18:47'),
(50, 6, 12, '2026-01-29 22:46:22', 1, NULL, 'rating', '2026-01-29 22:46:22', '2026-01-30 00:18:47'),
(51, 6, 12, '2026-01-29 22:46:22', 1, NULL, 'rating', '2026-01-29 22:46:22', '2026-01-30 00:18:47'),
(52, 6, 12, '2026-01-29 22:46:28', 0, NULL, 'view', '2026-01-29 22:46:28', '2026-01-30 00:18:47'),
(53, 6, 9, '2026-01-29 23:08:36', 1, NULL, 'rating', '2026-01-29 23:08:36', '2026-01-29 23:08:36'),
(54, 6, 9, '2026-01-29 23:08:36', 1, NULL, 'rating', '2026-01-29 23:08:36', '2026-01-29 23:08:36'),
(55, 6, 9, '2026-01-29 23:08:37', 0, NULL, 'cart', '2026-01-29 23:08:37', '2026-01-29 23:08:37'),
(56, 6, 9, '2026-01-29 23:08:37', 0, NULL, 'cart', '2026-01-29 23:08:37', '2026-01-29 23:08:37'),
(57, 6, 11, '2026-01-29 23:08:43', 1, NULL, 'rating', '2026-01-29 23:08:43', '2026-01-30 00:18:47'),
(58, 6, 11, '2026-01-29 23:08:43', 1, NULL, 'rating', '2026-01-29 23:08:43', '2026-01-30 00:18:47'),
(59, 6, 11, '2026-01-29 23:08:45', 0, NULL, 'cart', '2026-01-29 23:08:45', '2026-01-30 00:18:47'),
(60, 6, 11, '2026-01-29 23:08:45', 0, NULL, 'cart', '2026-01-29 23:08:45', '2026-01-30 00:18:47'),
(61, 6, 11, '2026-01-29 23:10:26', 1, NULL, 'rating', '2026-01-29 23:10:26', '2026-01-30 00:18:47'),
(62, 6, 11, '2026-01-29 23:10:26', 1, NULL, 'rating', '2026-01-29 23:10:26', '2026-01-30 00:18:47'),
(63, 6, 10, '2026-01-29 23:10:28', 1, NULL, 'rating', '2026-01-29 23:10:28', '2026-01-29 23:10:28'),
(64, 6, 10, '2026-01-29 23:10:28', 1, NULL, 'rating', '2026-01-29 23:10:28', '2026-01-29 23:10:28'),
(65, 6, 12, '2026-01-29 23:10:34', 1, NULL, 'rating', '2026-01-29 23:10:34', '2026-01-30 00:18:47'),
(66, 6, 12, '2026-01-29 23:10:34', 1, NULL, 'rating', '2026-01-29 23:10:34', '2026-01-30 00:18:47'),
(67, 6, 11, '2026-01-29 23:10:37', 0, NULL, 'view', '2026-01-29 23:10:37', '2026-01-30 00:18:47'),
(68, 6, 12, '2026-01-29 23:12:09', 0, NULL, 'view', '2026-01-29 23:12:09', '2026-01-30 00:18:47'),
(69, 6, 3, '2026-01-29 23:12:23', 0, NULL, 'view', '2026-01-29 23:12:23', '2026-01-29 23:12:23'),
(70, 6, 5, '2026-01-29 23:12:29', 0, NULL, 'rating', '2026-01-29 23:12:29', '2026-01-29 23:12:29'),
(71, 6, 6, '2026-01-29 23:13:08', 0, NULL, 'view', '2026-01-29 23:13:08', '2026-01-29 23:13:08'),
(72, 6, 5, '2026-01-29 23:13:13', 0, NULL, 'view', '2026-01-29 23:13:13', '2026-01-29 23:13:13'),
(73, 6, 3, '2026-01-29 23:13:16', 0, NULL, 'rating', '2026-01-29 23:13:16', '2026-01-29 23:13:16'),
(74, 6, 6, '2026-01-29 23:18:01', 1, NULL, 'rating', '2026-01-29 23:18:01', '2026-01-29 23:18:01'),
(75, 6, 6, '2026-01-29 23:18:01', 1, NULL, 'rating', '2026-01-29 23:18:01', '2026-01-29 23:18:01'),
(76, 6, 70, '2026-01-29 23:22:45', 1, NULL, 'rating', '2026-01-29 23:22:45', '2026-01-29 23:22:45'),
(77, 6, 70, '2026-01-29 23:22:45', 1, NULL, 'rating', '2026-01-29 23:22:45', '2026-01-29 23:22:45'),
(78, 6, 69, '2026-01-29 23:22:48', 0, NULL, 'rating', '2026-01-29 23:22:48', '2026-01-29 23:22:48'),
(79, 6, 12, '2026-01-29 23:26:17', 0, NULL, 'rating', '2026-01-29 23:26:17', '2026-01-30 00:18:47'),
(80, 6, 12, '2026-01-29 23:26:17', 1, NULL, 'rating', '2026-01-29 23:26:17', '2026-01-30 00:18:47'),
(81, 6, 12, '2026-01-29 23:26:17', 1, NULL, 'rating', '2026-01-29 23:26:17', '2026-01-30 00:18:47'),
(82, 6, 4, '2026-01-29 23:26:29', 1, NULL, 'rating', '2026-01-29 23:26:29', '2026-01-29 23:26:29'),
(83, 6, 4, '2026-01-29 23:26:29', 0, NULL, 'rating', '2026-01-29 23:26:29', '2026-01-29 23:26:29'),
(84, 6, 4, '2026-01-29 23:26:29', 1, NULL, 'rating', '2026-01-29 23:26:29', '2026-01-29 23:26:29'),
(85, 6, 69, '2026-01-29 23:26:39', 0, NULL, 'rating', '2026-01-29 23:26:39', '2026-01-29 23:26:39'),
(86, 6, 69, '2026-01-29 23:26:39', 1, NULL, 'rating', '2026-01-29 23:26:39', '2026-01-29 23:26:39'),
(87, 6, 69, '2026-01-29 23:26:39', 1, NULL, 'rating', '2026-01-29 23:26:39', '2026-01-29 23:26:39'),
(88, 6, 66, '2026-01-29 23:26:44', 1, NULL, 'rating', '2026-01-29 23:26:44', '2026-01-29 23:26:44'),
(89, 6, 66, '2026-01-29 23:26:44', 0, NULL, 'rating', '2026-01-29 23:26:44', '2026-01-29 23:26:44'),
(90, 6, 66, '2026-01-29 23:26:44', 1, NULL, 'rating', '2026-01-29 23:26:44', '2026-01-29 23:26:44'),
(91, 6, 4, '2026-01-30 00:20:37', 0, NULL, 'view', '2026-01-30 00:20:37', '2026-01-30 00:20:37'),
(92, 6, 4, '2026-01-30 00:20:43', 0, NULL, 'view', '2026-01-30 00:20:43', '2026-01-30 00:20:43'),
(93, 7, 1, '2026-01-30 13:28:17', 1, NULL, 'rating', '2026-01-30 13:28:17', '2026-01-30 13:28:17'),
(94, 7, 1, '2026-01-30 13:28:17', 0, NULL, 'rating', '2026-01-30 13:28:17', '2026-01-30 13:28:17'),
(95, 7, 1, '2026-01-30 13:28:17', 1, NULL, 'rating', '2026-01-30 13:28:17', '2026-01-30 13:28:17'),
(96, 7, 2, '2026-01-30 13:28:19', 1, NULL, 'rating', '2026-01-30 13:28:19', '2026-01-30 13:28:19'),
(97, 7, 2, '2026-01-30 13:28:19', 0, NULL, 'rating', '2026-01-30 13:28:19', '2026-01-30 13:28:19'),
(98, 7, 2, '2026-01-30 13:28:19', 1, NULL, 'rating', '2026-01-30 13:28:19', '2026-01-30 13:28:19'),
(99, 7, 3, '2026-01-30 13:28:22', 1, NULL, 'rating', '2026-01-30 13:28:22', '2026-01-30 13:28:22'),
(100, 7, 3, '2026-01-30 13:28:22', 0, NULL, 'rating', '2026-01-30 13:28:22', '2026-01-30 13:28:22'),
(101, 7, 3, '2026-01-30 13:28:22', 1, NULL, 'rating', '2026-01-30 13:28:22', '2026-01-30 13:28:22'),
(102, 7, 62, '2026-01-30 13:28:52', 1, NULL, 'rating', '2026-01-30 13:28:52', '2026-01-30 13:28:52'),
(103, 7, 62, '2026-01-30 13:28:52', 0, NULL, 'rating', '2026-01-30 13:28:52', '2026-01-30 13:28:52'),
(104, 7, 62, '2026-01-30 13:28:52', 1, NULL, 'rating', '2026-01-30 13:28:52', '2026-01-30 13:28:52'),
(105, 7, 62, '2026-01-30 13:28:54', 0, NULL, 'cart', '2026-01-30 13:28:54', '2026-01-30 13:28:54'),
(106, 7, 62, '2026-01-30 13:28:54', 0, NULL, 'cart', '2026-01-30 13:28:54', '2026-01-30 13:28:54'),
(107, 7, 63, '2026-01-30 13:28:55', 0, NULL, 'view', '2026-01-30 13:28:55', '2026-01-30 13:28:55'),
(108, 7, 60, '2026-01-30 13:28:59', 0, NULL, 'rating', '2026-01-30 13:28:59', '2026-01-30 13:28:59'),
(109, 7, 60, '2026-01-30 13:28:59', 0, NULL, 'rating', '2026-01-30 13:28:59', '2026-01-30 13:28:59'),
(110, 7, 2, '2026-01-30 14:21:48', 1, NULL, 'rating', '2026-01-30 14:21:48', '2026-01-30 14:21:48'),
(111, 7, 2, '2026-01-30 14:21:48', 1, NULL, 'rating', '2026-01-30 14:21:48', '2026-01-30 14:21:48'),
(112, 7, 2, '2026-01-30 14:21:50', 1, NULL, 'rating', '2026-01-30 14:21:50', '2026-01-30 14:21:50'),
(113, 7, 2, '2026-01-30 14:21:50', 1, NULL, 'rating', '2026-01-30 14:21:50', '2026-01-30 14:21:50'),
(114, 7, 6, '2026-01-30 14:21:53', 0, NULL, 'view', '2026-01-30 14:21:53', '2026-01-30 14:21:53'),
(115, 7, 10, '2026-01-30 14:22:01', 0, NULL, 'view', '2026-01-30 14:22:01', '2026-01-30 14:22:01'),
(116, 7, 65, '2026-01-30 14:22:04', 0, NULL, 'rating', '2026-01-30 14:22:04', '2026-01-30 14:22:04'),
(117, 7, 3, '2026-01-30 14:22:27', 1, NULL, 'rating', '2026-01-30 14:22:27', '2026-01-30 14:22:27'),
(118, 7, 3, '2026-01-30 14:22:27', 1, NULL, 'rating', '2026-01-30 14:22:27', '2026-01-30 14:22:27'),
(119, 7, 2, '2026-01-30 14:22:29', 1, NULL, 'rating', '2026-01-30 14:22:29', '2026-01-30 14:22:29'),
(120, 7, 2, '2026-01-30 14:22:29', 1, NULL, 'rating', '2026-01-30 14:22:29', '2026-01-30 14:22:29'),
(121, 7, 4, '2026-01-30 14:22:31', 1, NULL, 'rating', '2026-01-30 14:22:31', '2026-01-30 14:22:31'),
(122, 7, 4, '2026-01-30 14:22:31', 1, NULL, 'rating', '2026-01-30 14:22:31', '2026-01-30 14:22:31'),
(123, 7, 8, '2026-01-30 14:22:33', 1, NULL, 'rating', '2026-01-30 14:22:33', '2026-01-30 14:22:34'),
(124, 7, 8, '2026-01-30 14:22:34', 1, NULL, 'rating', '2026-01-30 14:22:34', '2026-01-30 14:22:34'),
(125, 7, 57, '2026-01-30 14:22:48', 0, NULL, 'cart', '2026-01-30 14:22:48', '2026-01-30 14:22:48'),
(126, 7, 55, '2026-01-30 14:22:49', 0, NULL, 'cart', '2026-01-30 14:22:49', '2026-01-30 14:22:49'),
(127, 7, 57, '2026-01-30 14:22:50', 0, NULL, 'view', '2026-01-30 14:22:50', '2026-01-30 14:22:50'),
(128, 7, 11, '2026-01-30 14:22:53', 0, NULL, 'rating', '2026-01-30 14:22:53', '2026-01-30 14:22:53'),
(129, 7, 4, '2026-01-30 14:23:06', 1, NULL, 'rating', '2026-01-30 14:23:06', '2026-01-30 14:23:06'),
(130, 7, 4, '2026-01-30 14:23:06', 1, NULL, 'rating', '2026-01-30 14:23:06', '2026-01-30 14:23:06'),
(131, 7, 8, '2026-01-30 14:23:11', 1, NULL, 'rating', '2026-01-30 14:23:11', '2026-01-30 14:23:11'),
(132, 7, 8, '2026-01-30 14:23:11', 1, NULL, 'rating', '2026-01-30 14:23:11', '2026-01-30 14:23:11'),
(133, 7, 62, '2026-01-30 14:23:28', 1, NULL, 'rating', '2026-01-30 14:23:28', '2026-01-30 14:23:28'),
(134, 7, 62, '2026-01-30 14:23:28', 1, NULL, 'rating', '2026-01-30 14:23:28', '2026-01-30 14:23:28'),
(135, 7, 65, '2026-01-30 14:23:33', 1, NULL, 'rating', '2026-01-30 14:23:33', '2026-01-30 14:23:33'),
(136, 7, 65, '2026-01-30 14:23:33', 1, NULL, 'rating', '2026-01-30 14:23:33', '2026-01-30 14:23:33'),
(137, 7, 1, '2026-01-30 14:29:56', 0, NULL, 'view', '2026-01-30 14:29:56', '2026-01-30 14:29:56'),
(138, 7, 1, '2026-01-30 14:30:02', 0, NULL, 'view', '2026-01-30 14:30:02', '2026-01-30 14:30:02'),
(139, 7, 1, '2026-01-30 14:30:10', 0, NULL, 'view', '2026-01-30 14:30:10', '2026-01-30 14:30:10'),
(140, 7, 1, '2026-01-30 14:30:15', 1, NULL, 'rating', '2026-01-30 14:30:15', '2026-01-30 14:30:15'),
(141, 7, 1, '2026-01-30 14:30:15', 1, NULL, 'rating', '2026-01-30 14:30:15', '2026-01-30 14:30:15'),
(142, 7, 2, '2026-01-30 14:30:18', 1, NULL, 'rating', '2026-01-30 14:30:18', '2026-01-30 14:30:18'),
(143, 7, 2, '2026-01-30 14:30:18', 1, NULL, 'rating', '2026-01-30 14:30:18', '2026-01-30 14:30:18'),
(144, 7, 6, '2026-01-30 14:30:23', 1, NULL, 'rating', '2026-01-30 14:30:23', '2026-01-30 14:30:23'),
(145, 7, 6, '2026-01-30 14:30:23', 1, NULL, 'rating', '2026-01-30 14:30:23', '2026-01-30 14:30:23'),
(146, 7, 6, '2026-01-30 14:30:26', 0, NULL, 'view', '2026-01-30 14:30:26', '2026-01-30 14:30:26'),
(147, 7, 52, '2026-01-30 14:30:28', 0, NULL, 'cart', '2026-01-30 14:30:28', '2026-01-30 14:30:28'),
(148, 7, 8, '2026-01-30 14:30:32', 0, NULL, 'cart', '2026-01-30 14:30:32', '2026-01-30 14:30:32'),
(149, 7, 11, '2026-01-30 14:30:41', 1, NULL, 'rating', '2026-01-30 14:30:41', '2026-01-30 14:30:41'),
(150, 7, 11, '2026-01-30 14:30:41', 1, NULL, 'rating', '2026-01-30 14:30:41', '2026-01-30 14:30:41'),
(151, 7, 57, '2026-01-30 14:30:46', 0, NULL, 'view', '2026-01-30 14:30:46', '2026-01-30 14:30:46'),
(152, 7, 60, '2026-01-30 14:30:51', 0, NULL, 'cart', '2026-01-30 14:30:51', '2026-01-30 14:30:51'),
(153, 7, 6, '2026-01-30 14:49:10', 1, NULL, 'rating', '2026-01-30 14:49:10', '2026-01-30 14:49:10'),
(154, 7, 6, '2026-01-30 14:49:10', 1, NULL, 'rating', '2026-01-30 14:49:10', '2026-01-30 14:49:10'),
(155, 7, 7, '2026-01-30 14:49:12', 1, NULL, 'rating', '2026-01-30 14:49:12', '2026-01-30 14:49:12'),
(156, 7, 7, '2026-01-30 14:49:12', 1, NULL, 'rating', '2026-01-30 14:49:12', '2026-01-30 14:49:12'),
(157, 7, 8, '2026-01-30 14:49:14', 1, NULL, 'rating', '2026-01-30 14:49:14', '2026-01-30 14:49:14'),
(158, 7, 8, '2026-01-30 14:49:14', 1, NULL, 'rating', '2026-01-30 14:49:14', '2026-01-30 14:49:14'),
(159, 7, 53, '2026-01-30 14:49:25', 1, NULL, 'rating', '2026-01-30 14:49:25', '2026-01-30 14:49:25'),
(160, 7, 53, '2026-01-30 14:49:25', 1, NULL, 'rating', '2026-01-30 14:49:25', '2026-01-30 14:49:25'),
(161, 7, 63, '2026-01-30 14:51:28', 0, NULL, 'view', '2026-01-30 14:51:28', '2026-01-30 14:51:28'),
(162, 7, 63, '2026-01-30 14:51:33', 0, NULL, 'view', '2026-01-30 14:51:33', '2026-01-30 14:51:33'),
(163, 7, 2, '2026-01-30 15:00:35', 0, NULL, 'view', '2026-01-30 15:00:35', '2026-01-30 15:00:35'),
(164, 7, 2, '2026-01-30 15:00:39', 0, NULL, 'view', '2026-01-30 15:00:39', '2026-01-30 15:00:39'),
(165, 7, 3, '2026-01-30 15:00:43', 0, NULL, 'view', '2026-01-30 15:00:43', '2026-01-30 15:00:43'),
(166, 7, 4, '2026-01-30 15:00:47', 0, NULL, 'view', '2026-01-30 15:00:47', '2026-01-30 15:00:47'),
(167, 7, 2, '2026-01-30 15:00:51', 1, NULL, 'rating', '2026-01-30 15:00:51', '2026-01-30 15:00:51'),
(168, 7, 2, '2026-01-30 15:00:51', 1, NULL, 'rating', '2026-01-30 15:00:51', '2026-01-30 15:00:51'),
(169, 7, 1, '2026-01-30 15:00:54', 1, NULL, 'rating', '2026-01-30 15:00:54', '2026-01-30 15:00:54'),
(170, 7, 1, '2026-01-30 15:00:54', 1, NULL, 'rating', '2026-01-30 15:00:54', '2026-01-30 15:00:54'),
(171, 7, 6, '2026-01-30 15:00:58', 1, NULL, 'rating', '2026-01-30 15:00:58', '2026-01-30 15:00:58'),
(172, 7, 6, '2026-01-30 15:00:58', 1, NULL, 'rating', '2026-01-30 15:00:58', '2026-01-30 15:00:58'),
(173, 7, 6, '2026-01-30 15:00:59', 0, NULL, 'view', '2026-01-30 15:00:59', '2026-01-30 15:00:59'),
(174, 7, 6, '2026-01-30 15:01:03', 0, NULL, 'view', '2026-01-30 15:01:03', '2026-01-30 15:01:03'),
(175, 7, 6, '2026-01-30 15:01:06', 0, NULL, 'cart', '2026-01-30 15:01:06', '2026-01-30 15:01:06'),
(176, 7, 7, '2026-01-30 15:01:07', 0, NULL, 'cart', '2026-01-30 15:01:07', '2026-01-30 15:01:07'),
(177, 7, 3, '2026-02-02 09:46:33', 0, NULL, 'cart', '2026-02-02 09:46:33', '2026-02-02 09:46:33'),
(178, 7, 3, '2026-02-02 09:46:33', 0, NULL, 'view', '2026-02-02 09:46:33', '2026-02-02 09:46:33'),
(179, 7, 1, '2026-02-02 09:46:54', 0, NULL, 'cart', '2026-02-02 09:46:54', '2026-02-02 09:46:54'),
(180, 7, 1, '2026-02-02 09:46:54', 0, NULL, 'view', '2026-02-02 09:46:54', '2026-02-02 09:46:54'),
(181, 7, 51, '2026-02-02 09:47:16', 0, NULL, 'cart', '2026-02-02 09:47:16', '2026-02-02 09:47:16'),
(182, 7, 51, '2026-02-02 09:47:16', 0, NULL, 'view', '2026-02-02 09:47:16', '2026-02-02 09:47:16'),
(183, 7, 1, '2026-02-02 09:47:30', 1, NULL, 'rating', '2026-02-02 09:47:30', '2026-02-02 09:47:30'),
(184, 7, 1, '2026-02-02 09:47:30', 1, NULL, 'rating', '2026-02-02 09:47:30', '2026-02-02 09:47:30'),
(185, 7, 4, '2026-02-02 09:47:34', 1, NULL, 'rating', '2026-02-02 09:47:34', '2026-02-02 09:47:34'),
(186, 7, 4, '2026-02-02 09:47:34', 1, NULL, 'rating', '2026-02-02 09:47:34', '2026-02-02 09:47:34'),
(187, 7, 7, '2026-02-02 09:47:39', 1, NULL, 'rating', '2026-02-02 09:47:39', '2026-02-02 09:47:39'),
(188, 7, 7, '2026-02-02 09:47:39', 1, NULL, 'rating', '2026-02-02 09:47:39', '2026-02-02 09:47:39'),
(189, 7, 6, '2026-02-02 09:47:41', 1, NULL, 'rating', '2026-02-02 09:47:41', '2026-02-02 09:47:41'),
(190, 7, 6, '2026-02-02 09:47:41', 1, NULL, 'rating', '2026-02-02 09:47:41', '2026-02-02 09:47:41'),
(191, 7, 3, '2026-02-02 09:48:23', 1, NULL, 'rating', '2026-02-02 09:48:23', '2026-02-02 09:48:23'),
(192, 7, 3, '2026-02-02 09:48:23', 1, NULL, 'rating', '2026-02-02 09:48:23', '2026-02-02 09:48:23'),
(193, 7, 2, '2026-02-02 09:52:30', 0, NULL, 'cart', '2026-02-02 09:52:30', '2026-02-02 09:52:30'),
(194, 7, 2, '2026-02-02 09:52:30', 0, NULL, 'view', '2026-02-02 09:52:30', '2026-02-02 09:52:30'),
(195, 7, 3, '2026-02-02 10:27:45', 0, NULL, 'cart', '2026-02-02 10:27:45', '2026-02-02 10:27:45'),
(196, 7, 3, '2026-02-02 10:27:45', 0, NULL, 'view', '2026-02-02 10:27:45', '2026-02-02 10:27:45'),
(197, 7, 3, '2026-02-02 10:37:14', 0, NULL, 'cart', '2026-02-02 10:37:14', '2026-02-02 10:37:14'),
(198, 7, 3, '2026-02-02 10:37:15', 0, NULL, 'view', '2026-02-02 10:37:15', '2026-02-02 10:37:15');

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `books`
--
ALTER TABLE `books`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_book_idx` (`title`,`author`),
  ADD KEY `category_id` (`category_id`);

--
-- Index pour la table `cart`
--
ALTER TABLE `cart`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_cart` (`user_id`,`book_id`),
  ADD KEY `book_id` (`book_id`);

--
-- Index pour la table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Index pour la table `ratings`
--
ALTER TABLE `ratings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_rating` (`user_id`,`book_id`),
  ADD KEY `book_id` (`book_id`);

--
-- Index pour la table `recommendation_stats`
--
ALTER TABLE `recommendation_stats`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_last_updated` (`last_updated`);

--
-- Index pour la table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Index pour la table `user_preferences`
--
ALTER TABLE `user_preferences`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_user_category` (`user_id`,`category_id`);

--
-- Index pour la table `user_preferred_authors`
--
ALTER TABLE `user_preferred_authors`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_user_author` (`user_id`,`author_name`);

--
-- Index pour la table `user_recommendations`
--
ALTER TABLE `user_recommendations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `book_id` (`book_id`),
  ADD KEY `idx_user_recommendations` (`user_id`,`recommended_at`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `books`
--
ALTER TABLE `books`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=720;

--
-- AUTO_INCREMENT pour la table `cart`
--
ALTER TABLE `cart`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=84;

--
-- AUTO_INCREMENT pour la table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT pour la table `ratings`
--
ALTER TABLE `ratings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=124;

--
-- AUTO_INCREMENT pour la table `recommendation_stats`
--
ALTER TABLE `recommendation_stats`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;

--
-- AUTO_INCREMENT pour la table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT pour la table `user_preferences`
--
ALTER TABLE `user_preferences`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=386;

--
-- AUTO_INCREMENT pour la table `user_preferred_authors`
--
ALTER TABLE `user_preferred_authors`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=386;

--
-- AUTO_INCREMENT pour la table `user_recommendations`
--
ALTER TABLE `user_recommendations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=199;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `books`
--
ALTER TABLE `books`
  ADD CONSTRAINT `books_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`);

--
-- Contraintes pour la table `cart`
--
ALTER TABLE `cart`
  ADD CONSTRAINT `cart_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `cart_ibfk_2` FOREIGN KEY (`book_id`) REFERENCES `books` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `ratings`
--
ALTER TABLE `ratings`
  ADD CONSTRAINT `ratings_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `ratings_ibfk_2` FOREIGN KEY (`book_id`) REFERENCES `books` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `recommendation_stats`
--
ALTER TABLE `recommendation_stats`
  ADD CONSTRAINT `recommendation_stats_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `user_preferences`
--
ALTER TABLE `user_preferences`
  ADD CONSTRAINT `user_preferences_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `user_preferred_authors`
--
ALTER TABLE `user_preferred_authors`
  ADD CONSTRAINT `user_preferred_authors_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `user_recommendations`
--
ALTER TABLE `user_recommendations`
  ADD CONSTRAINT `user_recommendations_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `user_recommendations_ibfk_2` FOREIGN KEY (`book_id`) REFERENCES `books` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
