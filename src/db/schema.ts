import { relations } from 'drizzle-orm';
import { pgTable, text, timestamp, integer, uuid } from 'drizzle-orm/pg-core';

export const users = pgTable('users', {
  id: uuid('id').defaultRandom().primaryKey(),
  name: text('name'),
  email: text('email').notNull().unique(),
  password: text('password').notNull(),
  emailVerificationId: uuid('email_verification_id').references(() => emailVerification.id),
  createdAt: timestamp('created_at', { withTimezone: true })
    .notNull()
    .defaultNow(),
});

export const emailVerification = pgTable('email_verification', {
  id: uuid('id').defaultRandom().primaryKey(),
  userId: uuid('user_id')
    .notNull()
    .unique()
    .references(() => users.id, { onDelete: 'cascade' }),
  createdAt: timestamp('created_at', { withTimezone: true })
    .notNull()
    .defaultNow(),
});

export const product = pgTable('product', {
    id: uuid('id').defaultRandom().primaryKey(),
    name: text('name').notNull().unique(),
    protein: integer('protein').notNull(),
    fat: integer('fat').notNull(),
    carbs: integer('carbs').notNull(),
    calories: integer('calories').notNull(),
    createdAt: timestamp('created_at', { withTimezone: true })
        .notNull()
        .defaultNow(),
});

export const usersRelations = relations(users, ({ one }) => ({
  emailVerification: one(emailVerification, {
    fields: [users.emailVerificationId],
    references: [emailVerification.id],
  }),
}));

export const emailVerificationRelations = relations(
  emailVerification,
  ({ one }) => ({
    user: one(users, {
      fields: [emailVerification.userId],
      references: [users.id],
    }),
  }),
);