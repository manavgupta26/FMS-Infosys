import SwiftUI
import FirebaseFirestore


struct DriverListView: View {
    @State private var users: [User] = []
    private let db = Firestore.firestore()
    
    var body: some View {
        List(users, id: \.id ) { user in
            VStack(alignment: .leading) {
                Text(user.name)
                    .font(.headline)
                Text("Email: \(user.email)")
                    .font(.subheadline)
                Text("Phone: \(user.phone)")
                    .font(.subheadline)
                Text("Role: \(user.role.rawValue)")
                    .font(.subheadline)
            }
            .padding()
        }
        .onAppear(perform: fetchUsersDriver)
        .navigationTitle("Drivers")
    }
    
    private func fetchUsersDriver() {
        db.collection("users").whereField("role", isEqualTo: "Driver").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents, error == nil else {
                print("Error fetching users: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            self.users = documents.compactMap { doc in
                let user = try? doc.data(as: User.self)
                return (user?.id != nil) ? user : nil
            }
        }
    }
    

}
