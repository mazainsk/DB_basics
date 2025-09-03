DROP TABLE IF EXISTS ArtistsAlbums;
DROP TABLE IF EXISTS GenresArtists;
DROP TABLE IF EXISTS TracksCollections;
DROP TABLE IF EXISTS Tracks CASCADE;
DROP TABLE IF EXISTS Albums;
DROP TABLE IF EXISTS Artists;
DROP TABLE IF EXISTS Genres;
DROP TABLE IF EXISTS Collections;

CREATE TABLE Genres (
	genre_id   SERIAL PRIMARY KEY,
	genre_name TEXT   UNIQUE NOT NULL
);

CREATE TABLE Artists (
	artist_id   SERIAL PRIMARY KEY,
	artist_name TEXT   UNIQUE NOT NULL
);

CREATE TABLE Albums (
	album_id    SERIAL PRIMARY KEY,
	album_name  TEXT   UNIQUE NOT NULL,
	create_date DATE   NOT NULL
				       CHECK (create_date BETWEEN '1900-01-01' AND CURRENT_DATE)
);

CREATE TABLE Collections (
	collection_id   SERIAL PRIMARY KEY,
	collection_name TEXT   UNIQUE NOT NULL,
	create_date     DATE   NOT NULL
					       CHECK (create_date BETWEEN '1900-01-01' AND CURRENT_DATE)
);

CREATE TABLE Tracks (
	track_id   SERIAL  PRIMARY KEY,
	track_name TEXT    NOT NULL,
	duration   INTEGER NOT NULL
			   		   CHECK (duration > 0),
	album_id   INTEGER REFERENCES Albums (album_id)
);

CREATE TABLE GenresArtists (
	ga_id     SERIAL  PRIMARY KEY,
	genre_id  INTEGER NOT NULL REFERENCES Genres(genre_id),
	artist_id INTEGER NOT NULL REFERENCES Artists(artist_id)
);

CREATE TABLE ArtistsAlbums (
	aa_id     SERIAL  PRIMARY KEY,
	artist_id INTEGER NOT NULL REFERENCES Artists(artist_id),
	album_id  INTEGER NOT NULL REFERENCES Albums(album_id)
);

CREATE TABLE TracksCollections (
	tc_id         SERIAL  PRIMARY KEY,
	track_id      INTEGER NOT NULL REFERENCES Tracks(track_id),
	collection_id INTEGER NOT NULL REFERENCES Collections(collection_id)
);

-- Задание 1
-- Заполнение полей каждой таблицы
INSERT INTO Artists (artist_name)
VALUES ('Артем Мельников'), ('Ксения Лебедева'), ('Группа "Зеленые огурцы"'), ('Дмитрий Ковалев'), ('Nafanya');

INSERT INTO Genres (genre_name)
VALUES ('Поп'), ('Рок'), ('Электронная музыка');
		
INSERT INTO Albums (album_name, create_date)
VALUES ('Светлые мечты', '2016-03-16'), ('Время любви', '2023-05-01'), ('Звуки леса', '1990-02-02'), ('People of the world', '2020-11-10'),
	   ('Другая "Бродячая собака"', '2019-07-24');

INSERT INTO Tracks (track_name, duration, album_id)
VALUES ('Небо в сердце', 195, 1), ('Вечный дождь', 220, 2), ('Гармония природы', 204, 3),
	   ('Путь к себе', 328, 1), ('Танцуй со мной', 308, 1), ('Звездная ночь', 245, 2),
	   ('From my favorite blossoms', 168, 3), ('Kenian tribes', 269, 4), ('Никогда-2', 218, 5);

INSERT INTO Collections (collection_name, create_date)
VALUES ('Лучшие хиты 2023', '2024-01-15'), ('Звуки молодости', '2018-09-23'), ('Летнее настроение', '2020-06-20'),
	   ('Сборник ретро', '2025-03-10'), ('Our rules. Nsk', '2021-04-21');

INSERT INTO ArtistsAlbums (artist_id, album_id)
VALUES (1, 1), (2, 2), (3, 3), (4, 1), (4, 4), (5, 5), (5, 4);

INSERT INTO GenresArtists (genre_id, artist_id)
VALUES (1, 1), (1, 2), (1, 4), (1, 5), (2, 4), (2, 5), (3, 3), (3, 2), (3, 5);

INSERT INTO TracksCollections (track_id, collection_id)
VALUES (1, 2), (1, 3), (2, 1), (3, 4), (3, 2), (4, 2), (5, 3), (6, 1), (7, 4), (9, 5);

-- Задание 2
-- Название и продолжительность самого длительного трека
SELECT track_name, duration FROM Tracks
ORDER BY duration DESC
LIMIT 1;

-- Название треков, продолжительность которых не менее 3,5 минут
SELECT track_name FROM Tracks
WHERE duration >= 210;

-- Названия сборников, вышедших в период с 2018 по 2020 год включительно
SELECT collection_name FROM Collections
WHERE EXTRACT(YEAR FROM create_date) BETWEEN 2018 AND 2020;

-- Исполнители, чьё имя состоит из одного слова
SELECT artist_name FROM Artists
WHERE artist_name ~ '^[^\s]+$';

-- Название треков, которые содержат слово «мой» или «my»
SELECT track_name FROM Tracks
WHERE track_name ILIKE '%my%' OR track_name ILIKE '%мой%';

-- Задание 3
-- Количество исполнителей в каждом жанре
SELECT g.genre_name, COUNT(ga.artist_id) FROM GenresArtists ga
JOIN Genres g ON ga.genre_id = g.genre_id
JOIN Artists a ON ga.artist_id = a.artist_id
GROUP BY g.genre_name;

-- Количество треков, вошедших в альбомы 2019–2020 годов
SELECT COUNT(t.track_id) AS track_count FROM Albums al
JOIN Tracks t ON t.album_id = al.album_id
WHERE EXTRACT(YEAR FROM al.create_date) BETWEEN 2019 AND 2020;
-- Вариант 2 - с выводом результатов по годам
--SELECT to_char(EXTRACT(YEAR FROM al.create_date), '0000') AS album_year,  COUNT(t.track_id) FROM albums al
--JOIN tracks t ON t.album_id = al.album_id
--WHERE EXTRACT(YEAR FROM al.create_date) BETWEEN 2019 AND 2020
--GROUP BY album_year
--ORDER BY album_year;

-- Средняя продолжительность треков по каждому альбому
SELECT album_name, AVG(t.duration) AS avg_track_duration FROM Albums al
JOIN Tracks t ON t.album_id = al.album_id
GROUP BY al.album_id
ORDER BY al.album_id;

-- Все исполнители, которые не выпустили альбомы в 2020 году
SELECT artist_name FROM Artists
WHERE artist_name NOT IN (
	SELECT artist_name FROM ArtistsAlbums aa
	JOIN Artists a ON aa.artist_id = a.artist_id
	JOIN Albums al ON aa.album_id = al.album_id
	WHERE EXTRACT(YEAR FROM al.create_date) = 2020
);

-- Названия сборников, в которых присутствует конкретный исполнитель (Дмитрий Ковалев)
SELECT collection_name FROM Collections c
JOIN TracksCollections tc ON tc.collection_id = c.collection_id 
JOIN Tracks t  ON tc.track_id = t.track_id 
JOIN Albums al ON t.album_id = al.album_id 
JOIN ArtistsAlbums aa ON aa.album_id = al.album_id 
JOIN Artists a ON aa.artist_id = a.artist_id 
WHERE a.artist_name = 'Дмитрий Ковалев'
GROUP BY c.collection_name;

-- Задание 4 (необязательное)
-- Названия альбомов, в которых присутствуют исполнители более чем одного жанра
SELECT DISTINCT album_name FROM Albums al
JOIN ArtistsAlbums aa ON aa.album_id = al.album_id
JOIN Artists a ON aa.artist_id = a.artist_id 
JOIN GenresArtists ga ON ga.artist_id = a.artist_id 
WHERE a.artist_id IN (
    SELECT ga1.artist_id
    FROM GenresArtists ga1
    GROUP BY ga1.artist_id
    HAVING COUNT(DISTINCT ga1.genre_id) > 1
);

-- Наименования треков, которые не входят в сборники
SELECT track_name, collection_id FROM Tracks t
LEFT JOIN TracksCollections tc ON tc.track_id = t.track_id 
WHERE collection_id IS NULL;

-- Исполнитель или исполнители, написавшие самый короткий по продолжительности трек, — теоретически таких треков может быть несколько
WITH MinDuration AS (
    SELECT MIN(duration) AS min_duration
    FROM Tracks
),
ShortestTracks AS (
    SELECT t.track_id
    FROM Tracks t
    JOIN MinDuration md ON t.duration = md.min_duration
)
SELECT DISTINCT ar.artist_name
FROM Artists ar
JOIN ArtistsAlbums aa ON ar.artist_id = aa.artist_id
JOIN Tracks t ON aa.album_id = t.album_id
JOIN ShortestTracks st ON t.track_id = st.track_id;

-- Названия альбомов, содержащих наименьшее количество треков
WITH Counts AS (
	SELECT album_name, count(t.track_id) AS track_count FROM Albums al 
	JOIN Tracks t ON t.album_id = al.album_id 
	GROUP BY al.album_id
),
MinCount AS (
	SELECT MIN(track_count) AS min_cnt FROM Counts
)
SELECT c.album_name, c.track_count FROM Counts c, MinCount
WHERE c.track_count = MinCount.min_cnt;
