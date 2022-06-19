import UIKit

// MARK: - Model

struct Todo: Codable {
    let id: Int
    let userId: Int
    let title: String
    let completed: Bool
}

// MARK: - Errors

enum TodoError: Error {
    case invalidRequest
    case failedToDecode
    case custom(error: Error)
}

// MARK: - Service
/*
struct TodoService {
    
    func fetch(completion: @escaping (Result<[Todo], Error>) -> Void) {
        
        let url = URL(string: "https://jsonplaceholder.typicode.com/todos")!
        URLSession
            .shared
            .dataTask(with: url) { data, response, error in
            
                DispatchQueue.main.async {
                    
                    if let error = error {
                        completion(.failure(TodoError.custom(error: error)))
                        return
                    }
                    
                    if let response = response as? HTTPURLResponse,
                       response.statusCode == 200 {
                        
                        guard let data = data,
                           let decodedData = try? JSONDecoder().decode([Todo].self, from: data) else {
                               completion(.failure(TodoError.failedToDecode))
                               return
                        }
                        
                        completion(.success(decodedData))
                        
                    } else {
                        completion(.failure(TodoError.invalidRequest))
                    }
                }

                
        }.resume()
    }
}
*/

struct TodoService {
    
    func fetch() async throws -> [Todo] {
        let url = URL(string: "https://jsonplaceholder.typicode.com/todos")!
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw TodoError.invalidRequest
        }
        
        let decodedData = try JSONDecoder().decode([Todo].self, from: data)
        return decodedData
    }
}

let service = TodoService()

Task {
    do {
        let todos = try await service.fetch()
        dump(todos)
    } catch {
        print(error)
    }
}


