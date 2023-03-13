import express from "express";
import PrismaService from "../services/prismaService";
import jwt from "jsonwebtoken";
import { attachUser } from "../middleware/attachUser";
import type { authenticated_user_req } from "../types";
export default function ({ app }: { app: express.Router }) {
  app.get("/users", async (req, res) => {
    try {
      const prismaService = PrismaService.getInstance();

      const users = await prismaService.client.user.findMany({
        include: {
          images: true,
        },
      });

      res.send(users);
    } catch (err) {
      console.log(err);
      res.status(500).send({
        message: "Internal server error",
      });
    }
  });

  app.get("/users/:userId/login", async (req, res) => {
    try {
      const prismaService = PrismaService.getInstance();

      const user = await prismaService.client.user.findUnique({
        where: {
          id: Number(req.params.userId),
        },
      });

      console.log(user);

      if (!user) {
        res.status(404).send({
          message: "User not found",
        });
        return;
      }

      const token = jwt.sign(
        {
          id: user.id,
        },
        "SECRET",
        {
          expiresIn: "18h",
        }
      );

      res.send({
        token,
      });
    } catch (err) {
      console.log(err);
      res.status(500).send({
        message: "Internal server error",
      });
    }
  });

  app.get("/users/me", attachUser, async (req: authenticated_user_req, res) => {
    try {
      const user = req.user!;

      const prismaService = PrismaService.getInstance();

      const userFromDB = await prismaService.client.user.findUnique({
        where: {
          id: user.id,
        },
        include: {
          images: true,
        },
      });

      res.send(userFromDB);
    } catch (err) {
      console.log(err);
      res.status(500).send({
        message: "Internal server error",
      });
    }
  });
}
