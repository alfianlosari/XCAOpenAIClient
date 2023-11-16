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
    
    public func generateSpeechFrom(input: String,
                                   model: Components.Schemas.CreateSpeechRequest.modelPayload.Value2Payload = .tts_hyphen_1,
                                   voice: Components.Schemas.CreateSpeechRequest.voicePayload = .alloy,
                                   format: Components.Schemas.CreateSpeechRequest.response_formatPayload = .aac
    ) async throws -> Data {
        let response = try await client.createSpeech(headers: .init(accept: [.init(contentType: .other("audio/mpeg"))]), body: .json(
            .init(
                model: .init(value1: nil, value2: .tts_hyphen_1),
                input: input,
                voice: .alloy,
                response_format: .aac
            )))
        
        switch response {
        case .ok(let response):
            switch response.body {
            case .binary(let body):
                var data = Data()
                for try await byte in body {
                    data.append(contentsOf: byte)
                }
                return data
            }
            
        case .undocumented(let statusCode, let payload):
            throw "OpenAIClientError - statuscode: \(statusCode), \(payload)"
        }
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
