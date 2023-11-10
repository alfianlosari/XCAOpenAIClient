import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

public struct OpenAIClient {
    
    public let client: Client
    
    public init(apiKey: String) {
        self.client = Client(
            serverURL: try! Servers.server1(),
            transport: URLSessionTransport(),
            middlewares: [AuthMiddleware(apiKey: apiKey)])
    }
    
    public func generateDallE3Image(prompt: String,
                                    quality: Components.Schemas.CreateImageRequest.qualityPayload = .standard,
                                    responseFormat: Components.Schemas.CreateImageRequest.response_formatPayload = .url,
                                    style: Components.Schemas.CreateImageRequest.stylePayload = .vivid
                                    
    ) async throws -> Components.Schemas.Image {
        
        let response = try await client.createImage(.init(body: .json(
            .init(
                prompt: prompt,
                model: .init(value1: nil, value2: .dall_hyphen_e_hyphen_3),
                n: 1,
                quality: quality,
                response_format: responseFormat,
                size: ._1024x1024,
                style: style
            ))))
        
        switch response {
        case .ok(let response):
            switch response.body {
            case .json(let imageResponse) where imageResponse.data.first != nil:
                return imageResponse.data.first!
                
            default:
                throw "Unknown response"
            }
            
        case .undocumented(let statusCode, let payload):
            throw "OpenAIClientError - statuscode: \(statusCode), \(payload)"
        }
    }
    
}
