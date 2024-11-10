import 'package:flutter/material.dart';

class TaskSummeryCard extends StatelessWidget {
  const TaskSummeryCard({
    super.key, required this.title, required this.count,
  });

  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      child: SizedBox(
        width: 110,
        child: Padding(
          padding:  const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$count',style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600
              ),),
              const SizedBox(height: 4,),
              FittedBox( //FittedBox for fit the child with the space
                child: Text(title,style: const TextStyle(
                    color: Colors.grey
                ),),
              )
            ],
          ),
        ),
      ),
    );
  }
}
