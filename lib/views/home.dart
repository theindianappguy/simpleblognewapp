import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:simpleblognewapp/services/crud.dart';
import 'package:simpleblognewapp/views/new_blog.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  QuerySnapshot blogsSnapshot;

  CrudMethods crudMethods = new CrudMethods();

  @override
  void initState() {
    crudMethods.getData().then((value) {
      blogsSnapshot = value;
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Flutter"),
            Text(
              "Blog",
              style: TextStyle(color: Colors.blue),
            )
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: <Widget>[
              blogsSnapshot != null ? ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: blogsSnapshot.documents.length,
                  itemBuilder: (context, index) {
                    return BlogTile(
                      blogImgUrl: blogsSnapshot.documents[index].data["imgUrl"],
                      title: blogsSnapshot.documents[index].data["title"],
                      description: blogsSnapshot.documents[index].data["desc"],
                      authorName:
                          blogsSnapshot.documents[index].data["authorName"],
                    );
                  }) : Container(
                height: MediaQuery.of(context).size.height,
                alignment: Alignment.center,
                child: CircularProgressIndicator(),)
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => NewBlog()));
        },
      ),
    );
  }
}

class BlogTile extends StatelessWidget {
  final String blogImgUrl, title, description, authorName;

  BlogTile(
      {@required this.blogImgUrl,
      @required this.title,
      @required this.authorName,
      @required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
              child: Image.network(blogImgUrl, height: 150,  width: MediaQuery.of(context).size.width, fit: BoxFit.cover,)),
          Container(
            decoration: BoxDecoration(
                color: Colors.black26,
              borderRadius: BorderRadius.circular(6),
            ),
            width: MediaQuery.of(context).size.width,
            height: 150,
           ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(title, style: TextStyle(fontSize: 22,fontWeight: FontWeight.w500),),

                Text(description, style: TextStyle(fontSize: 16),),

                Text(authorName, style: TextStyle(fontSize: 12),)
              ],
            ),
          )
        ],
      ),
    );
  }
}
