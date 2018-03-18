CREATE EXTENSION dblink;

DO
$do$
BEGIN
   IF EXISTS (SELECT 1 FROM pg_database WHERE datname = 'bookratedb') THEN
      RAISE NOTICE 'Database already exists';
   ELSE
      PERFORM dblink_exec('dbname=' || current_database()  -- current db
                        , 'CREATE DATABASE bookratedb');
   END IF;
END
$do$;

\connect bookratedb
--represents tables related to personalities
CREATE SCHEMA IF NOT EXISTS person;
--represents person roles

CREATE TABLE IF NOT EXISTS person.Roles (
  Id SMALLSERIAL PRIMARY KEY,
  RoleName VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS person.Genders (
  Id SMALLSERIAL PRIMARY KEY ,
  GenderName VARCHAR(10) UNIQUE
);

--represents a person entity
CREATE TABLE IF NOT EXISTS person.Persons (
  Id BIGSERIAL PRIMARY KEY ,
  Name VARCHAR(100) NOT NULL ,
  Surname VARCHAR(100) NOT NULL ,
  BirthDate DATE NOT NULL ,
  RecordDate TIMESTAMP WITH TIME ZONE NOT NULL,
  --navigation to credentials

  GenderId INTEGER REFERENCES person.Genders (Id)
);

CREATE TABLE IF NOT EXISTS person.Credentials (
  Id BIGSERIAL PRIMARY KEY,
  PersonId INTEGER REFERENCES person.Persons (Id),
  UserName VARCHAR(200) UNIQUE NOT NULL ,
  Pass VARCHAR(20) NOT NULL,
  IsUser BIT NOT NULL
);

CREATE TABLE IF NOT EXISTS person.Users (
  Id BIGSERIAL PRIMARY KEY ,
  PersonId INTEGER REFERENCES person.Persons (Id),
  CredentialId INTEGER REFERENCES person.Credentials (Id)
);
--represents tables related to objects
  CREATE SCHEMA IF NOT EXISTS object;

-- represents book categories
  CREATE TABLE IF NOT EXISTS object.Categories (
  Id SERIAL PRIMARY KEY ,
  CategoryName VARCHAR(50) UNIQUE  NOT NULL
);

--represents the book objects with unique ISBN number
  CREATE TABLE IF NOT EXISTS object.Book (
    Id BIGSERIAL PRIMARY KEY,
    CategoryId INTEGER REFERENCES object.Categories (Id),
    Title VARCHAR(200) NOT NULL , -- could be different versions -no unique
    Author VARCHAR(200) NOT NULL , -- could be same autors for different versions -nounique
    ISBN BIGINT NOT NULL UNIQUE,
    AveragePoint DOUBLE PRECISION NOT NULL ,
    CumulativeRaterCount INTEGER NOT NULL
  );

-- represents a single comment entry

  CREATE TABLE IF NOT EXISTS object.Comments (
    Id BIGSERIAL UNIQUE NOT NULL ,
    Content VARCHAR(500) NOT NULL,
    BookId INTEGER REFERENCES object.Book(Id),
    UserId INTEGER REFERENCES person.Users (Id),

    PRIMARY KEY (BookId,UserId)
  );

  CREATE TABLE IF NOT EXISTS object.Rates (
    Id BIGSERIAL UNIQUE NOT NULL,
    Value INTEGER NOT NULL ,
    UserId INTEGER REFERENCES person.Users (Id),
    BookId INTEGER REFERENCES object.Book(Id),

    PRIMARY KEY (UserId,BookId)
  );

------Helper Tables
--represents many to many tables

CREATE SCHEMA IF NOT EXISTS helper;

CREATE TABLE IF NOT EXISTS helper.BookCategory(
  BookId INTEGER REFERENCES  object.Book(Id),
  CategoryId INTEGER REFERENCES object.Categories (Id),

  PRIMARY KEY (BookId,CategoryId)
);

  CREATE TABLE IF NOT EXISTS helper.PersonRole(
    PersonId INTEGER REFERENCES person.Persons (Id),
    RoleId INTEGER REFERENCES person.Roles (Id),

    PRIMARY KEY (PersonId,RoleId)
  );


  ---Data Initialization

--ROLE

INSERT INTO person.Roles (RoleName) VALUES ('Admin');
INSERT INTO person.Roles (RoleName) VALUES ('Employee');
INSERT INTO person.Roles (RoleName) VALUES ('User');


-- CATEGORY
INSERT INTO object.Categories (CategoryName) VALUES ('Science');
INSERT INTO object.Categories (CategoryName) VALUES ('Novel');
INSERT INTO object.Categories (CategoryName) VALUES ('Philosophy');
INSERT INTO object.Categories (CategoryName) VALUES ('Technology');

-- GENDER

INSERT INTO person.Genders (GenderName) VALUES ('Male');
INSERT INTO person.Genders (GenderName) VALUES ('Female');
INSERT INTO person.Genders (GenderName) VALUES ('NA');

--PERSON
INSERT INTO person.Persons (Name, Surname, BirthDate, RecordDate, GenderId) VALUES('Olgun', 'Erguzel', '1984-07-29', '1992-06-06', 1);
INSERT INTO person.Persons (Name, Surname, BirthDate, RecordDate, GenderId) VALUES('Edward', 'Witten', '1951-09-26', '1992-06-07', 1);
INSERT INTO person.Persons (Name, Surname, BirthDate, RecordDate, GenderId) VALUES('Ludwig', 'Boltzmann', '1844-02-20', '1992-06-08', 1);
INSERT INTO person.Persons (Name, Surname, BirthDate, RecordDate, GenderId) VALUES('Kelly', 'Buckminster', '1995-05-30 ', '2005-06-06 ', 2);
INSERT INTO person.Persons (Name, Surname, BirthDate, RecordDate, GenderId) VALUES('Sierra', 'Rafael', '1967-04-25 ', '2016-07-01 ', 1);
INSERT INTO person.Persons (Name, Surname, BirthDate, RecordDate, GenderId) VALUES('Wynter', 'Suki', '1974-03-14 ', '1998-12-10 ', 2);
INSERT INTO person.Persons (Name, Surname, BirthDate, RecordDate, GenderId) VALUES('Janna', 'Keely', '1983-06-18 ', '1993-08-27 ', 3);

INSERT INTO person.Credentials (PersonId, UserName, Pass, IsUser) VALUES (1, 'olgunerguzel', 'oe123456', '1');
INSERT INTO person.Credentials (PersonId, UserName, Pass, IsUser) VALUES (2, 'mtheory', 'ew654321', '1');
INSERT INTO person.Credentials (PersonId, UserName, Pass, IsUser) VALUES (3, 'kblnomega', 'ew654321', '1');
INSERT INTO person.Credentials (PersonId, UserName, Pass, IsUser) VALUES (4, 'kelbuck', 'kb2125', '1');
INSERT INTO person.Credentials (PersonId, UserName, Pass, IsUser) VALUES (5, 'sieraf', 'sr89432', '1');
INSERT INTO person.Credentials (PersonId, UserName, Pass, IsUser) VALUES (6, 'wysuk', 'ws234534', '0');
INSERT INTO person.Credentials (PersonId, UserName, Pass, IsUser) VALUES (7, 'jake', 'jk4325', '0');

INSERT INTO person.Users (PersonId, CredentialId) VALUES (1, 1);
INSERT INTO person.Users (PersonId, CredentialId) VALUES (2, 2);
INSERT INTO person.Users (PersonId, CredentialId) VALUES (3, 3);
INSERT INTO person.Users (PersonId, CredentialId) VALUES (4, 4);
INSERT INTO person.Users (PersonId, CredentialId) VALUES (5, 5);

INSERT INTO helper.PersonRole(PersonId, RoleId) VALUES (1,1);
INSERT INTO helper.PersonRole(PersonId, RoleId) VALUES (1,2);

INSERT INTO helper.PersonRole(PersonId, RoleId) VALUES (2,3);
INSERT INTO helper.PersonRole(PersonId, RoleId) VALUES (3,3);

INSERT INTO helper.PersonRole(PersonId, RoleId) VALUES (4,2);
INSERT INTO helper.PersonRole(PersonId, RoleId) VALUES (4,3);

INSERT INTO helper.PersonRole(PersonId, RoleId) VALUES (5,2);
INSERT INTO helper.PersonRole(PersonId, RoleId) VALUES (5,3);

INSERT INTO helper.PersonRole(PersonId, RoleId) VALUES (6,3);
INSERT INTO helper.PersonRole(PersonId, RoleId) VALUES (7,3);
