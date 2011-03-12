CREATE TABLE "brands" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "schema_migrations" ("version" varchar(255) NOT NULL);
CREATE TABLE "searches" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "term" varchar(255), "brand_id" integer, "created_at" datetime, "updated_at" datetime);
CREATE INDEX "index_searches_on_brand_id" ON "searches" ("brand_id");
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
INSERT INTO schema_migrations (version) VALUES ('20110119060914');

INSERT INTO schema_migrations (version) VALUES ('20110312213657');