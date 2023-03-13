import express from "express";
import type { user } from "@prisma/client";

export type authenticated_user_req = express.Request & {
  user?: user;
};
