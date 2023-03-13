import jwt from "jsonwebtoken";
import PrismaService from "../services/prismaService";

export const attachUser = async (req: any, res: any, next: any) => {
  try {
    const token = req.headers.authorization.split(" ")[1];
    const decodedToken = jwt.verify(token, "SECRET");
    const userId = (decodedToken as unknown as any).id;
    const prismaService = PrismaService.getInstance();

    const user = await prismaService.client.user.findUnique({
      where: {
        id: userId,
      },
    });

    if (!user) {
      throw new Error("User not found!");
    }

    req.user = user;
    next();
  } catch {
    res.status(401).json({
      error: "Invalid request!",
    });
  }
};
 
