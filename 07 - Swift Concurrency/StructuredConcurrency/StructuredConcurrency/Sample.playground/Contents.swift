import UIKit
import Foundation

// MARK: Models

struct User: Codable {
    let id: Int
    let name: String
    let username: String
}

struct Post: Codable {
    let id: Int
    let userId: Int
    let title: String
    let body: String
}

struct ContentService {
    
    typealias Content = (users: [User], post: [Post])
    
    enum ContentError: Error {
        case invalidRequest
        case failedToDecode
        case custom(error: Error)
    }
    
    let usersUrl = URL(string: "https://jsonplaceholder.typicode.com/users")!
    let postssUrl = URL(string: "https://jsonplaceholder.typicode.com/posts")!
    
    
    func fetchContent() async throws -> Content {
        
        let users = try await fetch(usersUrl, type: [User].self)
        let posts = try await fetch(postssUrl, type: [Post].self)
        
        return (users, posts)
    }
    
    private func fetch<T: Codable>(_ url: URL, type: T.Type) async throws -> T {
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw ContentError.invalidRequest
        }
        
        let decodedData = try JSONDecoder().decode(T.self, from: data)
        return decodedData

    }
}

let service = ContentService()

Task {
    
    do {
        let data = try await service.fetchContent()
        print("start of users")
        dump(data.users)
        print("start of posts")
        dump(data.post)
    } catch {
        print(error)
        
    }
    
    
}
