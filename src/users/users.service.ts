import { Injectable } from '@nestjs/common';
import { eq } from 'drizzle-orm';
import { DrizzleService } from '../db/drizzle.service';
import { emailVerification, users } from '../db/schema';

export interface CreateUserInput {
  email: string;
  name?: string | null;
}

@Injectable()
export class UsersService {
  constructor(private readonly drizzle: DrizzleService) {}

  async createUser(input: CreateUserInput) {
    return this.drizzle.client.transaction(async (tx) => {
      const [user] = await tx
        .insert(users)
        .values({ email: input.email, name: input.name ?? null })
        .returning();

      const [verification] = await tx
        .select()
        .from(emailVerification)
        .where(eq(emailVerification.userId, user.id));

      return { user, emailVerification: verification };
    });
  }
}
