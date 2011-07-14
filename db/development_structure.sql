CREATE TABLE "brands" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "schema_migrations" ("version" varchar(255) NOT NULL);
CREATE TABLE "search_results" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "search_id" integer, "body" text, "source" text, "url" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "searches" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "term" varchar(255), "brand_id" integer, "created_at" datetime, "updated_at" datetime, "latest_id" varchar(255));
CREATE INDEX "index_search_results_on_search_id" ON "search_results" ("search_id");
CREATE INDEX "index_searches_on_brand_id" ON "searches" ("brand_id");
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
INSERT INTO schema_migrations (version) VALUES ('20110119060914');

INSERT INTO schema_migrations (version) VALUES ('20110312213657');

INSERT INTO schema_migrations (version) VALUES ('20110611132712');

INSERT INTO schema_migrations (version) VALUES ('20110713195147');