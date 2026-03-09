import 'dart:io';

List<Map<String, dynamic>> students = [];

void main() {
  while (true) {
    print("\n===== Student Management System =====");
    print("1. Add Student");
    print("2. View Students");
    print("3. Update Student");
    print("4. Delete Student");
    print("5. Exit");
    stdout.write("Choose an option: ");

    String? choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        addStudent();
        break;
      case '2':
        viewStudents();
        break;
      case '3':
        updateStudent();
        break;
      case '4':
        deleteStudent();
        break;
      case '5':
        print("Program exited.");
        return;
      default:
        print("Invalid choice!");
    }
  }
}

void addStudent() {
  stdout.write("Enter ID: ");
  int id = int.parse(stdin.readLineSync()!);

  stdout.write("Enter Name: ");
  String name = stdin.readLineSync()!;

  stdout.write("Enter Age: ");
  int age = int.parse(stdin.readLineSync()!);

  students.add({"id": id, "name": name, "age": age});

  print("Student added successfully!");
}

void viewStudents() {
  if (students.isEmpty) {
    print("No students found!");
    return;
  }

  print("\n--- Student List ---");
  for (var student in students) {
    print(
      "ID: ${student['id']}, Name: ${student['name']}, Age: ${student['age']}",
    );
  }
}

void updateStudent() {
  stdout.write("Enter Student ID to update: ");
  int id = int.parse(stdin.readLineSync()!);

  for (var student in students) {
    if (student['id'] == id) {
      stdout.write("Enter New Name: ");
      student['name'] = stdin.readLineSync()!;

      stdout.write("Enter New Age: ");
      student['age'] = int.parse(stdin.readLineSync()!);

      print("Student updated successfully!");
      return;
    }
  }

  print("Student not found!");
}

void deleteStudent() {
  stdout.write("Enter Student ID to delete: ");
  int id = int.parse(stdin.readLineSync()!);

  students.removeWhere((student) => student['id'] == id);

  print("Student deleted (if existed).");
}
