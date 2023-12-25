import 'package:codesofttask1/dbhelpers/dbhelper.dart';
import 'package:codesofttask1/models/notesmodel.dart';
import 'package:flutter/material.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({Key? key}) : super(key: key);

  @override
  State<Homescreen> createState() => _HomescreenState();
}
class _HomescreenState extends State<Homescreen> {
  DbHelper? dbHelper;
  late Future<List<Notesmodel>> notelist;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper();
    loaddata();
  }

  loaddata() async {
    notelist = dbHelper!.getnotelist();
  }

  void _showBottomSheet(bool isEditing, Notesmodel? existingData) {
    titleController.text = isEditing ? existingData!.title : '';
    descriptionController.text = isEditing ? existingData!.description : '';

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title',border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20)))),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description',border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20)))),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (isEditing) {
                    // Update existing task
                    existingData!.title = titleController.text;
                    existingData.description = descriptionController.text;
                    dbHelper!.update(existingData);
                  } else {
                    // Add new task
                    dbHelper!.insert(
                      Notesmodel(
                        title: titleController.text,
                        description: descriptionController.text,
                      ),
                    );
                  }

                  // Reload data and close the bottom sheet
                  setState(() {
                    notelist = dbHelper!.getnotelist();
                  });
                  Navigator.pop(context);
                },
                child: Text(isEditing ? 'Update Task' : 'Add Task'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: 
      Container(
        alignment: Alignment.bottomCenter,
        child: InkWell(
          onTap: () {
            _showBottomSheet(false, null);
          },
          child: Container(
            height: 70,
            width: 160,
            decoration: BoxDecoration(
              
              borderRadius: BorderRadius.circular(30.0),
              gradient: LinearGradient(
                colors: [Colors.red.shade400, Colors.red.shade700],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: const Center(
              child: Text(
                "ADD TASK",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text('SoftCode tasks'),
      ),
      body: Column(
        children: [
         Padding(
           padding: const EdgeInsets.only(right: 80),
           child: Container(
             height: 70,
             width: double.infinity,
             decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(bottomRight: Radius.circular(60)),
               gradient: LinearGradient(
                 colors: [Colors.red.shade400, Colors.red.shade700],
                 begin: Alignment.topCenter,
                 end: Alignment.bottomCenter,
               ),
             ),
             child:  const Padding(
               padding: EdgeInsets.all(16.0),
               child: Text(
                   "Muhammad Waqas",
                   style: TextStyle(
                     color: Colors.white,
                     fontSize: 30,
                     fontWeight: FontWeight.bold,
                   ),
                 
               ),
             ),
           ),
         ),
          const SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 170,
              width: double.infinity,
              
              decoration: BoxDecoration(
                 boxShadow: const [
          BoxShadow(
            color: Colors.black26, // Shadow color
            offset: Offset(0, 4), // Shadow position (x, y)
            blurRadius: 8.0, // Shadow blur radius
          ),
        ],
                image: const DecorationImage(image: AssetImage('assets/todo.jpg',),fit: BoxFit.fitWidth),
                color: const Color.fromARGB(255, 215, 118, 118),
                borderRadius: BorderRadius.circular(20),
              ),
              
            ),
          ),
          const SizedBox(height: 10,),
          const Text('Your Tasks',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red,fontSize: 20,),),
          Expanded(
            child: FutureBuilder(
              future: notelist,
              builder: (context, AsyncSnapshot<List<Notesmodel>?> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.black12,
                          child: const Icon(Icons.delete_forever_sharp),
                        ),
                        onDismissed: (DismissDirection direction) {
                          setState(() {
                            dbHelper!.delete(snapshot.data![index].id!);
                            notelist = dbHelper!.getnotelist();
                            snapshot.data!.remove(snapshot.data![index]);
                          });
                        },
                        key: ValueKey<int>(snapshot.data![index].id!),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20,right: 20,top: 10),
                          child: Card(
                            elevation: 4,
                            child: ListTile(
                              title: Text(snapshot.data![index].title.toString()),
                              subtitle:Text(snapshot.data![index].description.toString()) ,
                              trailing: Checkbox(
                                value: snapshot.data![index].isCompleted,
                                onChanged: (value) {
                                  setState(() {
                                    snapshot.data![index].isCompleted = value ?? false;
                                    dbHelper!.update(snapshot.data![index]);
                                  });
                                },
                              ),
                              onTap: () {
                                _showBottomSheet(true, snapshot.data![index]);
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
                return const Center(child: Text('No Data Added'),);
              },
            ),
          ),
        ],
      ),
    );
  }
}
