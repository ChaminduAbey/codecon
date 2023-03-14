"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const prismaService_1 = __importDefault(require("../services/prismaService"));
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
const attachUser_1 = require("../middleware/attachUser");
function default_1({ app }) {
    app.get("/users", (req, res) => __awaiter(this, void 0, void 0, function* () {
        try {
            const prismaService = prismaService_1.default.getInstance();
            const users = yield prismaService.client.user.findMany({
                include: {
                    images: true,
                },
            });
            res.send(users);
        }
        catch (err) {
            console.log(err);
            res.status(500).send({
                message: "Internal server error",
            });
        }
    }));
    app.get("/users/:userId/login", (req, res) => __awaiter(this, void 0, void 0, function* () {
        try {
            const prismaService = prismaService_1.default.getInstance();
            const user = yield prismaService.client.user.findUnique({
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
            const token = jsonwebtoken_1.default.sign({
                id: user.id,
            }, "SECRET", {
                expiresIn: "18h",
            });
            res.send({
                token,
            });
        }
        catch (err) {
            console.log(err);
            res.status(500).send({
                message: "Internal server error",
            });
        }
    }));
    app.get("/users/me", attachUser_1.attachUser, (req, res) => __awaiter(this, void 0, void 0, function* () {
        try {
            const user = req.user;
            const prismaService = prismaService_1.default.getInstance();
            const userFromDB = yield prismaService.client.user.findUnique({
                where: {
                    id: user.id,
                },
                include: {
                    images: true,
                },
            });
            res.send(userFromDB);
        }
        catch (err) {
            console.log(err);
            res.status(500).send({
                message: "Internal server error",
            });
        }
    }));
}
exports.default = default_1;
