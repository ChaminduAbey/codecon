import express from "express";
import PrismaService from "../services/prismaService";

export default function ({ app }: { app: express.Router }) {
  app.get("/projects/:projectId", async (req, res) => {
    try {
      const prismaService = PrismaService.getInstance();

      const project = await prismaService.client.projects.findUnique({
        where: {
          id: Number(req.params.projectId),
        },
        include: {
          reviews: {
            include: {
              user: {
                include: {
                  images: true,
                },
              },
            },
          },

          images: true,
          issuer: {
            include: {
              images: true,
            },
          },
          contractor: {
            include: {
              images: true,
            },
          },
        },
      });

      const bidders = await prismaService.client.bidders.findMany({
        where: {
          project_id: Number(req.params.projectId),
        },
        include: {
          contractor: {
            include: {
              images: true,
            },
          },
        },
      });

      const biddersAsContractorsList = bidders.map(
        (bidder) => bidder.contractor
      );

      (project as unknown as any).bidders = biddersAsContractorsList;

      res.send(project);
    } catch (err) {
      console.log(err);
      res.status(500).send({
        message: "Internal server error",
      });
    }
  });

  app.get("/projects", async (req, res) => {
    try {
      const prismaService = PrismaService.getInstance();

      const projects = await prismaService.client.projects.findMany({
        include: {
          images: true,

          issuer: {
            include: {
              images: true,
            },
          },
          contractor: {
            include: {
              images: true,
            },
          },
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

  app.get("/projects/:projectId/timeline", async (req, res) => {
    try {
      const prismaService = PrismaService.getInstance();

      const timeline = await prismaService.client.timeline.findMany({
        where: {
          project_id: Number(req.params.projectId),
        },
        orderBy: {
          order: "asc",
        },
      });

      res.send(timeline);
    } catch (err) {
      console.log(err);
      res.status(500).send({
        message: "Internal server error",
      });
    }
  });

  app.get("/issuers/:issuerId", async (req, res) => {
    try {
      const prismaService = PrismaService.getInstance();

      const issuer = await prismaService.client.issuer.findUnique({
        where: {
          id: Number(req.params.issuerId),
        },
        include: {
          images: true,
          projects: {
            include: {
              images: true,
            },
          },
        },
      });

      const reviews = await prismaService.client.reviews.findMany({
        where: {
          project_id: {
            in: issuer?.projects.map((project) => project.id) || [],
          },
        },
        include: {
          user: {
            include: {
              images: true,
            },
          },
        },
      });

      (issuer as unknown as any).reviews = reviews;

      if (!issuer) {
        res.status(404).send({
          message: "Issuer not found",
        });
        return;
      }

      res.send(issuer);
    } catch (err) {
      console.log(err);
      res.status(500).send({
        message: "Internal server error",
      });
    }
  });

  app.get("/contractors/:contractorId", async (req, res) => {
    try {
      const prismaService = PrismaService.getInstance();

      const issuer = await prismaService.client.contractor.findUnique({
        where: {
          id: Number(req.params.contractorId),
        },
        include: {
          images: true,

          projects: {
            include: {
              images: true,
            },
          },
        },
      });

      const reviews = await prismaService.client.reviews.findMany({
        where: {
          project_id: {
            in: issuer?.projects.map((project) => project.id) || [],
          },
        },
        include: {
          user: {
            include: {
              images: true,
            },
          },
        },
      });

      (issuer as unknown as any).reviews = reviews;

      if (!issuer) {
        res.status(404).send({
          message: "Issuer not found",
        });
        return;
      }

      res.send(issuer);
    } catch (err) {
      console.log(err);
      res.status(500).send({
        message: "Internal server error",
      });
    }
  });
}
