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
