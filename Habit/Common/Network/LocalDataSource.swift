import Foundation
import Combine

class LocalDataSource {
    static let instance: LocalDataSource = LocalDataSource()

    private init() {}

    private func saveValue(value: UserAuth) {
        UserDefaults.standard.setValue(try? PropertyListEncoder().encode(value), forKey: "user_key")
    }

    private func readValue(forKey key: String) -> UserAuth? {
        var userAuth: UserAuth?

        if let data = UserDefaults.standard.value(forKey: key) as? Data {
            userAuth = try? PropertyListDecoder().decode(UserAuth.self, from: data)
        }

        return userAuth
    }
}

extension LocalDataSource {
    func saveUserOnUserDefaults(userAuth: UserAuth) {
        saveValue(value: userAuth)
    }

    func getUserOnUserDefaults() -> Future<UserAuth?, Never> {
        let userAuth = readValue(forKey: "user_key")

        return Future<UserAuth?, Never> { promise in promise(.success(userAuth)) }
    }
}
