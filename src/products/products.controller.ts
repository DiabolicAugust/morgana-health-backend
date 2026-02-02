import { Body, Controller, Get, Post } from "@nestjs/common";
import {  ProductsService } from "./products.service";
import { CreateProductInputDto } from "./dto/create-product-input.dto";

@Controller('products')
export class ProductsController {
  constructor(private readonly productsService: ProductsService) {}

  @Post()
  createProduct(@Body() input: CreateProductInputDto) {
    return this.productsService.createProduct(input);
  }
  
  @Get()
  getAllProducts() {
    return this.productsService.getAllProducts();
  }
}
