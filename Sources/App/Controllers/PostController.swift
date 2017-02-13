import Vapor
import HTTP

final class PostController: ResourceRepresentable {
    func addRoutes(drop: Droplet) {
        drop.get("/", handler: postsPage)
        drop.post("/post/create", handler: create)
        drop.get("/all", handler: index)
        drop.get("/post/:post_id/delete", handler: deletePost)
    }
    
    func deletePost(request: Request) throws -> ResponseRepresentable {
        guard let postId = request.parameters["post_id"]?.string else { throw Abort.badRequest }
        let post = try Post.query().filter("id", postId)
        try post.delete()
        return Response(redirect: "/")
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
        return Response(redirect: "/")
    }

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
