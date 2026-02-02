import { Module } from '@nestjs/common';
import { DrizzleModule } from '../db/drizzle.module';
import { UsersService } from './users.service';

@Module({
  imports: [DrizzleModule],
  providers: [UsersService],
  exports: [UsersService],
})
export class UsersModule {}
