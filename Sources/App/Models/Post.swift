import Vapor
import Fluent
import Foundation

final class Post: Model {
    var id: Node?
    var post_content: String
    var post_title: String
    var post_image_url: String
    var post_color: String
    var exists: Bool = false
    
    init(_ post_content: String, _ post_title: String, _ post_image_url: String, _ post_color: String) {
        self.id = nil
        self.post_content = post_content
        self.post_title = post_title
        self.post_image_url = post_image_url
        self.post_color = post_color
    }

    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        post_content = try node.extract("post_content")
        post_title = try node.extract("post_title")
        post_image_url = try node.extract("post_image_url")
        post_color = try node.extract("post_color")
    }

    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "post_content": post_content,
            "post_title": post_title,
            "post_image_url": post_image_url,
            "post_color": post_color
        ])
    }
}

extension Post: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create("posts") { posts in
            posts.id()
            posts.string("post_title")
            posts.string("post_content")
            posts.string("post_image_url")
            posts.string("post_color")
        }
    }

    static func revert(_ database: Database) throws {
        try database.delete("posts")
    }
}
