CREATE TABLE "email_verification" (
	"id" serial PRIMARY KEY NOT NULL,
	"user_id" integer NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "email_verification_user_id_unique" UNIQUE("user_id")
);
--> statement-breakpoint
CREATE TABLE "users" (
	"id" serial PRIMARY KEY NOT NULL,
	"name" text,
	"email" text NOT NULL,
	"email_verification_id" integer,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "users_email_unique" UNIQUE("email")
);
--> statement-breakpoint
ALTER TABLE "email_verification" ADD CONSTRAINT "email_verification_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "users" ADD CONSTRAINT "users_email_verification_id_email_verification_id_fk" FOREIGN KEY ("email_verification_id") REFERENCES "public"."email_verification"("id") ON DELETE no action ON UPDATE no action;
--> statement-breakpoint
CREATE OR REPLACE FUNCTION create_email_verification_for_user()
RETURNS TRIGGER AS $$
DECLARE
	verification_id INTEGER;
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