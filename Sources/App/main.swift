import Vapor
import VaporPostgreSQL
let postsController = PostController()
let drop = Droplet()
drop.preparations.append(Post.self)

do {
    try drop.addProvider(VaporPostgreSQL.Provider.self)
} catch {
    assertionFailure("Error adding provider: \(error)")
}


drop.get { req in
    return try drop.view.make("welcome")
}


drop.resource("posts", postsController)

drop.run()
