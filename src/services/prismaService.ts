import { PrismaClient } from "@prisma/client";

export default class PrismaService {
  private static instance: PrismaService;
  readonly client: PrismaClient;

  private constructor() {
    this.client = new PrismaClient();
  }

  static getInstance() {
    if (!PrismaService.instance) {
      PrismaService.instance = new PrismaService();
    }
    return PrismaService.instance;
  }
}
