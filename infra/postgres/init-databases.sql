-- Separate database for each service (database-per-service)
CREATE DATABASE parkup_user;
CREATE DATABASE parkup_parking;
CREATE DATABASE parkup_booking;
CREATE DATABASE parkup_payment;

\connect parkup_parking
CREATE EXTENSION IF NOT EXISTS postgis;
