import Foundation
import Combine

class ContentViewModel: ObservableObject {
    @Published var objcHelper: ObjCHelper?
    
    init() {
        objcHelper = ObjCHelper()
    }
}
