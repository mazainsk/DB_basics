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