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
    
    public func generateImage(prompt: String, model: Components.Schemas.CreateImageRequest.modelPayload.Value2Payload = .dall_hyphen_e_hyphen_3, responseFormat: Components.Schemas.CreateImageRequest.response_formatPayload = .url, size: Components.Schemas.CreateImageRequest.sizePayload = ._512x512) async throws -> Components.Schemas.Image {
        
        let response = try await client.createImage(.init(body: .json(
            .init(
                prompt: prompt,
                model: .init(value1: nil, value2: model),
                n: 1,
                response_format: responseFormat,
                size: size
            ))))
        
        switch response {
        case .ok(let response):
            switch response.body {
            case .json(let imageResponse) where imageResponse.data.first != nil:
                return imageResponse.data.first!
            default:
                throw "Unknown response"
            }
        default:
            throw "Failed to generate image"
        }
    }
    
}
