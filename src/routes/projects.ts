import express from "express";
import PrismaService from "../services/prismaService";

export default function ({ app }: { app: express.Router }) {
  app.get("/projects", async (req, res) => {
    try {
      const prismaService = PrismaService.getInstance();

      const projects = await prismaService.client.projects.findMany({
        include: {
          images: true,
        },
      });

      res.send(projects);
    } catch (err) {
      console.log(err);
      res.status(500).send({
        message: "Internal server error",
      });
    }
  });
}
