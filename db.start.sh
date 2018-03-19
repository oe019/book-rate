#!/bin/bash
##
## prepares the database by providing username information
##

if  [ $# -eq 0 ];
then
    echo "please provide postgres username as a parameter";
    echo "no other parameters supported";
    exit 1;
fi

cat >> bookratedb.sql <<- "EOF"
CREATE EXTENSION dblink;

DO
$do$
BEGIN
  IF EXISTS(SELECT 1
            FROM pg_database
            WHERE datname = 'bookratedb')
  THEN
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

CREATE SCHEMA IF NOT EXISTS forum;
--represents person roles

CREATE TABLE IF NOT EXISTS forum.Badges(
  Id SMALLSERIAL PRIMARY KEY,
  BadgeName VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS person.Roles (
  Id       SMALLSERIAL PRIMARY KEY,
  RoleName VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS person.Genders (
  Id         SMALLSERIAL PRIMARY KEY,
  GenderName VARCHAR(20) UNIQUE
);

--represents a person entity
CREATE TABLE IF NOT EXISTS person.Persons (
  Id         BIGSERIAL PRIMARY KEY,
  Name       VARCHAR(100)             NOT NULL,
  Surname    VARCHAR(100)             NOT NULL,
  BirthDate  DATE                     NOT NULL,
  RecordDate TIMESTAMP WITH TIME ZONE NOT NULL,
  GenderId   INTEGER REFERENCES person.Genders (Id)
);

CREATE TABLE IF NOT EXISTS person.Credentials (
  Id       BIGSERIAL PRIMARY KEY,
  PersonId INTEGER REFERENCES person.Persons (Id),
  RoleId   INTEGER REFERENCES person.Roles (Id),
  Email    VARCHAR(100)        NOT NULL UNIQUE,
  UserName VARCHAR(100) UNIQUE NOT NULL,
  Pass     VARCHAR(20)         NOT NULL,
  IsUser   BIT                 NOT NULL
);

CREATE TABLE IF NOT EXISTS person.Users (
  Id           BIGSERIAL PRIMARY KEY,
  PersonId     INTEGER REFERENCES person.Persons (Id),
  CredentialId INTEGER REFERENCES person.Credentials (Id),
  BadgeId INTEGER REFERENCES forum.Badges(Id)
  --rank etc badge
);
--represents tables related to objects
CREATE SCHEMA IF NOT EXISTS object;

-- represents book categories
CREATE TABLE IF NOT EXISTS object.Categories (
  Id           SERIAL PRIMARY KEY,
  CategoryName VARCHAR(50) UNIQUE  NOT NULL
);

--represents the book objects with unique ISBN number
CREATE TABLE IF NOT EXISTS object.Book (
  Id                   BIGSERIAL PRIMARY KEY,
  CategoryId           INTEGER REFERENCES object.Categories (Id),
  Title                VARCHAR(200)     NOT NULL, -- could be different versions -no unique
  Author               VARCHAR(200)     NOT NULL, -- could be same autors for different versions -nounique
  ISBN                 BIGINT           NOT NULL UNIQUE,
  AveragePoint         DOUBLE PRECISION NOT NULL,
  CumulativeRaterCount INTEGER          NOT NULL
);

-- represents a single comment entry

CREATE TABLE IF NOT EXISTS object.Comments (
  Id      BIGSERIAL UNIQUE NOT NULL,
  Content VARCHAR(500)     NOT NULL,
  BookId  INTEGER REFERENCES object.Book (Id),
  UserId  INTEGER REFERENCES person.Users (Id),

  PRIMARY KEY (BookId, UserId)
);

CREATE TABLE IF NOT EXISTS object.Rates (
  Id     BIGSERIAL UNIQUE NOT NULL,
  Value  INTEGER          NOT NULL,
  UserId INTEGER REFERENCES person.Users (Id),
  BookId INTEGER REFERENCES object.Book (Id),

  PRIMARY KEY (UserId, BookId)
);

------Helper Tables
--represents many to many tables

CREATE SCHEMA IF NOT EXISTS helper;

CREATE TABLE IF NOT EXISTS helper.BookCategory (
  BookId     INTEGER REFERENCES object.Book (Id),
  CategoryId INTEGER REFERENCES object.Categories (Id),

  PRIMARY KEY (BookId, CategoryId)
);

CREATE TABLE IF NOT EXISTS helper.PersonCredential (
  PersonId     INTEGER REFERENCES person.Persons (Id),
  CredentialId INTEGER REFERENCES person.Credentials (Id),

  PRIMARY KEY (PersonId, CredentialId)
);

---Data Initialization

--ROLE

INSERT INTO person.Roles (RoleName) VALUES ('Admin');
INSERT INTO person.Roles (RoleName) VALUES ('Employee');
INSERT INTO person.Roles (RoleName) VALUES ('User');

INSERT INTO forum.Badges (BadgeName) VALUES ('Member');
INSERT INTO forum.Badges (BadgeName) VALUES ('Noble');
INSERT INTO forum.Badges (BadgeName) VALUES ('VIP');

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
INSERT INTO person.Persons (Name, Surname, BirthDate, RecordDate, GenderId)
VALUES ('Olgun', 'Erguzel', '1984-07-29', '1992-06-06', 1);
INSERT INTO person.Persons (Name, Surname, BirthDate, RecordDate, GenderId)
VALUES ('Edward','Witten', '1951-09-26', '1992-06-07', 1);
INSERT INTO person.Persons (Name, Surname, BirthDate, RecordDate, GenderId)
VALUES ('Ludwig','Boltzman', '1844-02-20', '1992-06-08', 1);
INSERT INTO person.Persons (Name, Surname, BirthDate, RecordDate, GenderId)
VALUES ('Kelly','Husch', '1995-05-30 ', '2005-06-06 ', 2);
INSERT INTO person.Persons (Name, Surname, BirthDate, RecordDate, GenderId)
VALUES ('Sierra','Houston', '1967-04-25 ', '2016-07-01 ', 1);
INSERT INTO person.Persons (Name, Surname, BirthDate, RecordDate, GenderId)
VALUES ('Wynter', 'Suki', '1974-03-14 ', '1998-12-10 ', 2);
INSERT INTO person.Persons (Name, Surname, BirthDate, RecordDate, GenderId)
VALUES ('Janna', 'Keely', '1983-06-18 ', '1993-08-27 ', 3);


INSERT INTO person.Credentials (PersonId, RoleId, Email, UserName, Pass, IsUser)
VALUES (1, 1, 'olgunerguzel@email.com', 'olgunerg', 'p@oe12345', '0');


INSERT INTO person.Credentials (PersonId, RoleId, Email, UserName, Pass, IsUser)
VALUES (1, 2, 'oe019@uni-rostock.de', 'oe019', 'p@55w0rd', '0');

INSERT INTO person.Credentials (PersonId, RoleId, Email, UserName, Pass, IsUser)
VALUES (1, 3, 'sriperg@gmail.com', 'sriperg', 'sr1234', '1');

INSERT INTO person.Credentials (PersonId, RoleId, Email, UserName, Pass, IsUser)
VALUES (2, 2,'edwitten@yahoo.com', 'mtheory', 'ew654321', '0');
INSERT INTO person.Credentials (PersonId, RoleId, Email, UserName, Pass, IsUser)
VALUES (3, 2,'boltzman@gmail.com', 'kblnomega', 'ew654321', '0');
INSERT INTO person.Credentials (PersonId, RoleId, Email, UserName, Pass, IsUser)
VALUES (4, 2,'kbuck@hotmail.com', 'kelbuck', 'kb2125', '0');
INSERT INTO person.Credentials (PersonId, RoleId, Email, UserName, Pass, IsUser)
VALUES (5, 3,'sierrarafael@gmail.com', 'sieraf', 'sr89432', '1');
INSERT INTO person.Credentials (PersonId, RoleId, Email, UserName, Pass, IsUser)
VALUES (6, 3,'wytnersu@yandex.com', 'wysuk', 'ws234534', '1');
INSERT INTO person.Credentials (PersonId, RoleId, Email, UserName, Pass, IsUser)
VALUES (7, 3,'jannakelly@msn.com', 'jake', 'jk4325', '1');

INSERT INTO person.Users (PersonId, CredentialId, BadgeId) VALUES (1, 3, 2);
INSERT INTO person.Users (PersonId, CredentialId, BadgeId) VALUES (5, 7 ,1);
INSERT INTO person.Users (PersonId, CredentialId, BadgeId) VALUES (6, 8 ,2);
INSERT INTO person.Users (PersonId, CredentialId, BadgeId) VALUES (7, 9 ,3);




INSERT INTO helper.PersonCredential (PersonId, CredentialId) VALUES (1, 1);
INSERT INTO helper.PersonCredential (PersonId, CredentialId) VALUES (1, 2);
INSERT INTO helper.PersonCredential (PersonId, CredentialId) VALUES (1, 3);
INSERT INTO helper.PersonCredential (PersonId, CredentialId) VALUES (2, 4);
INSERT INTO helper.PersonCredential (PersonId, CredentialId) VALUES (3, 5);
INSERT INTO helper.PersonCredential (PersonId, CredentialId) VALUES (4, 6);
INSERT INTO helper.PersonCredential (PersonId, CredentialId) VALUES (5, 7);
INSERT INTO helper.PersonCredential (PersonId, CredentialId) VALUES (6, 8);
INSERT INTO helper.PersonCredential (PersonId, CredentialId) VALUES (7, 9);

-- procedures

CREATE OR REPLACE FUNCTION add_user(name       VARCHAR(100), surname VARCHAR(100), birthdate DATE,
                                    recorddate TIMESTAMP WITH TIME ZONE, genderid INT, userName VARCHAR(100),
                                    email      VARCHAR(100), pasword VARCHAR(100))
  RETURNS INTEGER AS $$
DECLARE
  instertedPersonId    INTEGER;
  insertedCredentialId INTEGER;
BEGIN
  INSERT INTO person.Persons(Name, Surname, BirthDate, RecordDate, GenderId)
  VALUES (name, surname, birthdate, recorddate, genderid)
  RETURNING Persons.Id
    INTO instertedPersonId;

  INSERT INTO person.Credentials(PersonId, RoleId, Email, UserName, Pass, IsUser)
  VALUES (instertedPersonId,3, email, userName, pasword, 1)
  RETURNING Credentials.Id
    INTO insertedCredentialId;

  INSERT INTO person.Users(PersonId, CredentialId,BadgeId) VALUES (instertedPersonId,insertedCredentialId,1);
  INSERT INTO helper.PersonCredential(PersonId, CredentialId) VALUES (instertedPersonId,insertedCredentialId);

  RETURN instertedPersonId;

END;
$$
LANGUAGE plpgsql;

EOF

##uncomment following 2 lines if the postgresql is not installed on mac server
#/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
#brew install postgresql

psql postgres -f ./bookratedb.sql -U $1 $2

##rm -r -f bookratedb.sql

## mac server

