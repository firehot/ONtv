DROP TABLE IF EXISTS "DefaultFavorite";
CREATE TABLE "DefaultFavorite" ("id" INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL , "channel_id" INTEGER, "channel_order" INTEGER);
DROP TABLE IF EXISTS "User";
CREATE TABLE "User" ("user_id" INTEGER PRIMARY KEY  NOT NULL ,"name" VARCHAR,"email" VARCHAR,"phone" VARCHAR,"password" TEXT,"subscription" VARCHAR,"deviceSummaryListing" VARCHAR,"defaultReminderType" VARCHAR, "defaultReminderTime" VARCHAR, "defaultReminderbeforeType" VARCHAR, "defaultHoursType" VARCHAR, "defaultDaysType" VARCHAR);
DROP TABLE IF EXISTS "cache_all";
CREATE TABLE "cache_all" ("id" INTEGER PRIMARY KEY  NOT NULL ,"user" VARCHAR,"email" VARCHAR,"data_type" VARCHAR,"cache_data" VARCHAR,"expiry_tag" VARCHAR);
