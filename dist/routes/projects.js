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
function default_1({ app }) {
    app.get("/projects/:projectId", (req, res) => __awaiter(this, void 0, void 0, function* () {
        try {
            const prismaService = prismaService_1.default.getInstance();
            const project = yield prismaService.client.projects.findUnique({
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
            const bidders = yield prismaService.client.bidders.findMany({
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
            const biddersAsContractorsList = bidders.map((bidder) => bidder.contractor);
            project.bidders = biddersAsContractorsList;
            res.send(project);
        }
        catch (err) {
            console.log(err);
            res.status(500).send({
                message: "Internal server error",
            });
        }
    }));
    app.get("/projects", (req, res) => __awaiter(this, void 0, void 0, function* () {
        try {
            const prismaService = prismaService_1.default.getInstance();
            const projects = yield prismaService.client.projects.findMany({
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
        }
        catch (err) {
            console.log(err);
            res.status(500).send({
                message: "Internal server error",
            });
        }
    }));
    app.get("/projects/:projectId/timeline", (req, res) => __awaiter(this, void 0, void 0, function* () {
        try {
            const prismaService = prismaService_1.default.getInstance();
            const timeline = yield prismaService.client.timeline.findMany({
                where: {
                    project_id: Number(req.params.projectId),
                },
                orderBy: {
                    order: "asc",
                },
            });
            res.send(timeline);
        }
        catch (err) {
            console.log(err);
            res.status(500).send({
                message: "Internal server error",
            });
        }
    }));
    app.get("/issuers/:issuerId", (req, res) => __awaiter(this, void 0, void 0, function* () {
        try {
            const prismaService = prismaService_1.default.getInstance();
            const issuer = yield prismaService.client.issuer.findUnique({
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
            const reviews = yield prismaService.client.reviews.findMany({
                where: {
                    project_id: {
                        in: (issuer === null || issuer === void 0 ? void 0 : issuer.projects.map((project) => project.id)) || [],
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
            issuer.reviews = reviews;
            if (!issuer) {
                res.status(404).send({
                    message: "Issuer not found",
                });
                return;
            }
            res.send(issuer);
        }
        catch (err) {
            console.log(err);
            res.status(500).send({
                message: "Internal server error",
            });
        }
    }));
    app.get("/contractors/:contractorId", (req, res) => __awaiter(this, void 0, void 0, function* () {
        try {
            const prismaService = prismaService_1.default.getInstance();
            const issuer = yield prismaService.client.contractor.findUnique({
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
            const reviews = yield prismaService.client.reviews.findMany({
                where: {
                    project_id: {
                        in: (issuer === null || issuer === void 0 ? void 0 : issuer.projects.map((project) => project.id)) || [],
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
            issuer.reviews = reviews;
            if (!issuer) {
                res.status(404).send({
                    message: "Issuer not found",
                });
                return;
            }
            res.send(issuer);
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
