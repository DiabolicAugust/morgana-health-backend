CREATE EXTENSION IF NOT EXISTS "pgcrypto";
--> statement-breakpoint
DROP TRIGGER IF EXISTS trg_create_email_verification ON users;
--> statement-breakpoint
DROP FUNCTION IF EXISTS create_email_verification_for_user();
--> statement-breakpoint
DROP TABLE IF EXISTS "email_verification" CASCADE;
--> statement-breakpoint
DROP TABLE IF EXISTS "users" CASCADE;
--> statement-breakpoint
DROP TABLE IF EXISTS "product" CASCADE;
--> statement-breakpoint
CREATE TABLE "users" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"name" text,
	"email" text NOT NULL,
	"password" text NOT NULL,
	"email_verification_id" uuid,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "users_email_unique" UNIQUE("email")
);
--> statement-breakpoint
CREATE TABLE "email_verification" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"user_id" uuid NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "email_verification_user_id_unique" UNIQUE("user_id")
);
--> statement-breakpoint
CREATE TABLE "product" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"name" text NOT NULL,
	"protein" integer NOT NULL,
	"fat" integer NOT NULL,
	"carbs" integer NOT NULL,
	"calories" integer NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "product_name_unique" UNIQUE("name")
);
--> statement-breakpoint
ALTER TABLE "email_verification" ADD CONSTRAINT "email_verification_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;
--> statement-breakpoint
ALTER TABLE "users" ADD CONSTRAINT "users_email_verification_id_email_verification_id_fk" FOREIGN KEY ("email_verification_id") REFERENCES "public"."email_verification"("id") ON DELETE no action ON UPDATE no action;
--> statement-breakpoint
CREATE OR REPLACE FUNCTION create_email_verification_for_user()
RETURNS TRIGGER AS $$
DECLARE
	verification_id uuid;
BEGIN
	INSERT INTO email_verification (user_id)
	VALUES (NEW.id)
	RETURNING id INTO verification_id;

	UPDATE users
	SET email_verification_id = verification_id
	WHERE id = NEW.id;

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;
--> statement-breakpoint
DROP TRIGGER IF EXISTS trg_create_email_verification ON users;
--> statement-breakpoint
CREATE TRIGGER trg_create_email_verification
AFTER INSERT ON users
FOR EACH ROW
EXECUTE FUNCTION create_email_verification_for_user();
