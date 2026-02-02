import { Injectable } from '@nestjs/common';
import { eq } from 'drizzle-orm';
import { DrizzleService } from '../db/drizzle.service';
import { product } from '../db/schema';

export interface CreateProductInput {
  name: string;
  protein: number;
  fat: number;
  carbs: number;
  calories: number;
}

export type UpdateProductInput = Partial<CreateProductInput>;

@Injectable()
export class ProductsService {
  constructor(private readonly drizzle: DrizzleService) {}

  async createProduct(input: CreateProductInput) {
    return this.drizzle.client.insert(product).values(input);
  }

  async getProduct(id: string) {
    return this.drizzle.client.select().from(product).where(eq(product.id, id));
  }

  async updateProduct(id: string, input: UpdateProductInput) {
    return this.drizzle.client
      .update(product)
      .set(input)
      .where(eq(product.id, id));
  }

  async getAllProducts() {
    return this.drizzle.client.select().from(product);
  }
}