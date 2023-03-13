import express from "express";
import PrismaService from "../services/prismaService";
import z from "zod";
import { validateZod } from "../middleware/validateZod";
import { attachUser } from "../middleware/attachUser";
import { authenticated_user_req } from "../types";

const reviewSchema = z.object({
  body: z.object({
    review: z.string(),
    rating: z.number().nullable(),
    project_id: z.number(),
  }),
});

export default function ({ app }: { app: express.Router }) {
  app.post(
    "/reviews",

    validateZod(reviewSchema),
    attachUser,
    async (req: authenticated_user_req, res) => {
      try {
        const user = req.user!;

        const prismaService = PrismaService.getInstance();

        console.log(user);

        const review = await prismaService.client.reviews.create({
          data: {
            review: req.body.review,
            rating: req.body.rating,
            user: {
              connect: {
                id: user.id,
              },
            },
            projects: {
              connect: {
                id: req.body.project_id,
              },
            },
          },
        });

        res.send(review);
      } catch (err) {
        console.log(err);
        res.status(500).send({
          message: "Internal server error",
        });
      }
    }
  );
}
