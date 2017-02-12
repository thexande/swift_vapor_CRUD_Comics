import Vapor
import VaporPostgreSQL

let postsController = PostController()
let drop = Droplet()

do {
    try drop.addProvider(VaporPostgreSQL.Provider.self)
} catch {
    assertionFailure("Error adding provider: \(error)")
}

drop.preparations.append(Post.self)
postsController.addRoutes(drop: drop)

drop.resource("posts", postsController)

drop.run()
