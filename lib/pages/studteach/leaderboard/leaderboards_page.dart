import 'package:eat_caias/constants.dart';
import 'package:eat_caias/pages/studteach/leaderboard/leaderboards_helper.dart';
import 'package:flutter/material.dart';

class LeaderboardsPage extends StatelessWidget {
  const LeaderboardsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('eat.caias / '),
            Text(
              'leaderboards',
              style: TextStyle(color: Colors.amber.shade800),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            mainPointsCard(21),
            const SizedBox(height: 10),
            ListTile(
              title: Row(
                children: [
                  const Text(
                    'Leaderboards / ',
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                  Text(
                    'Top 10',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.amber.shade800,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: Padding(
                padding: cardPadding,
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: leaderboards.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Text(
                          leaderboards[index]['rank'],
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        title: Text(
                          '🥇 ${leaderboards[index]['name']}',
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        subtitle: Text(
                          'Points: ${leaderboards[index]['points']}',
                        ),
                      );
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget mainPointsCard(int points) {
    return Padding(
      padding: cardPadding,
      child: Card(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              ListTile(
                leading: const Text(
                  '🔥',
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
                title: Text(
                  'You have $points points',
                  style: const TextStyle(
                    fontSize: 22,
                  ),
                ),
              ),
              const Text(
                'Order more from our canteens, refer a friend to eat.caias, unlock achievements to earn more points!',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {},
                    style: mainButtonsStyle,
                    child: const Text('Refer a Friend'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {},
                    style: mainButtonsStyle,
                    child: const Text('Redeem Points'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
