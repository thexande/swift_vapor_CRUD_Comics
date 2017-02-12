import Vapor
import HTTP

final class PostController: ResourceRepresentable {
    func addRoutes(drop: Droplet) {
        drop.get("/", handler: home)
        drop.get("/all", handler: postsPage)
        drop.post("/post/create", handler: create)
//        drop.get("/all", handler: index)
    }
    
    func index(request: Request) throws -> ResponseRepresentable {
        return try Post.all().makeNode().converted(to: JSON.self)
    }
    
    func home(request: Request) throws -> ResponseRepresentable {
        return try drop.view.make("welcome")
    }
    
    func postsPage(request: Request) throws -> ResponseRepresentable {
        let posts = try Post.all().makeNode()
        let params = try Node(node: [
            "posts": posts
            ])
        return try drop.view.make("posts_root", params)
    }
    
    func create(request: Request) throws -> ResponseRepresentable {
        var post = try request.post()
        try post.save()
        return Response(redirect: "/all")
    }
//
//    func show(request: Request, post: Post) throws -> ResponseRepresentable {
//        return post
//    }
//
//    func delete(request: Request, post: Post) throws -> ResponseRepresentable {
//        try post.delete()
//        return JSON([:])
//    }
//
//    func clear(request: Request) throws -> ResponseRepresentable {
//        try Post.query().delete()
//        return JSON([])
//    }
//
//    func update(request: Request, post: Post) throws -> ResponseRepresentable {
//        let new = try request.post()
//        var post = post
//        post.content = new.content
//        try post.save()
//        return post
//    }
//
//    func replace(request: Request, post: Post) throws -> ResponseRepresentable {
//        try post.delete()
//        return try create(request: request)
//    }

    func makeResource() -> Resource<Post> {
        return Resource(
            index: index,
            store: create
//            show: show,
//            replace: replace,
//            modify: update,
//            destroy: delete,
//            clear: clear
        )
    }
}

extension Request {
    func post() throws -> Post {
        guard let postContent = data["post_content"]?.string else { throw Abort.badRequest }
        guard let postTitle = data["post_title"]?.string else { throw Abort.badRequest }
        guard let postImageUrl = data["post_image_url"]?.string else { throw Abort.badRequest }
        guard let postColor = data["post_color"]?.string else { throw Abort.badRequest }
        return Post(postContent, postTitle, postImageUrl, postColor)
    }
}
