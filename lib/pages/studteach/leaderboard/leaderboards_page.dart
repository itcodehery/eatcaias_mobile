import 'package:eat_caias/constants.dart';
import 'package:eat_caias/pages/studteach/leaderboard/leaderboards_helper.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LeaderboardsPage extends StatefulWidget {
  const LeaderboardsPage({Key? key}) : super(key: key);

  @override
  State<LeaderboardsPage> createState() => _LeaderboardsPageState();
}

class _LeaderboardsPageState extends State<LeaderboardsPage> {
  int points = 0;
  List<Map<String, dynamic>> leaderboardsTop10 = [];
  List<Map<String, dynamic>> popularCanteenTop10 = [];
  List<Map<String, dynamic>> popularFoodItemTop10 = [];

  @override
  void initState() {
    _fetchUserPoints();
    _fetchPopularCanteen();
    _fetchPopularFoodItems();
    super.initState();
  }

  //fetch user points
  Future<void> _fetchUserPoints() async {
    try {
      final userData = await supabase
          .from('studteach_user')
          .select()
          .eq('email', supabase.auth.currentUser?.email as String)
          .single();
      final achievers = await supabase.from('studteach_user').select();
      achievers.sort(
        (a, b) => (b['points'] as int).compareTo(a['points'] as int),
      );

      if (userData.isNotEmpty) {
        setState(() {
          points = userData["points"] as int;
          leaderboardsTop10 =
              achievers.length < 10 ? achievers : achievers.sublist(0, 10);
        });
      } else {
        return;
      }
    } on PostgrestException catch (error) {
      if (mounted) {
        SnackBar(
          content: Text(error.message),
          backgroundColor: Theme.of(context).colorScheme.error,
        );
      }
    } catch (error) {
      if (mounted) {
        SnackBar(
          content: const Text('Unexpected error occurred'),
          backgroundColor: Theme.of(context).colorScheme.error,
        );
      }
    }
  }

  //fetch popular canteens
  Future<void> _fetchPopularCanteen() async {
    try {
      final canteenData = await supabase.from('canteen_shop').select();
      canteenData.sort(
        (a, b) => (b['order_count'] as int).compareTo(a['order_count'] as int),
      );
      if (canteenData.isNotEmpty) {
        setState(() {
          popularCanteenTop10 = canteenData.length < 10
              ? canteenData
              : canteenData.sublist(0, 10);
        });
      } else {
        return;
      }
    } on PostgrestException catch (error) {
      if (mounted) {
        SnackBar(
          content: Text(error.message),
          backgroundColor: Theme.of(context).colorScheme.error,
        );
      }
    } catch (error) {
      if (mounted) {
        SnackBar(
          content: const Text('Unexpected error occurred'),
          backgroundColor: Theme.of(context).colorScheme.error,
        );
      }
    }
  }

  //fetch most ordered food items
  Future<void> _fetchPopularFoodItems() async {
    try {
      final foodData = await supabase.from('menu_item').select();
      foodData.sort(
        (a, b) => (b['order_count'] as int).compareTo(a['order_count'] as int),
      );
      if (foodData.isNotEmpty) {
        setState(() {
          popularFoodItemTop10 =
              foodData.length < 10 ? foodData : foodData.sublist(0, 10);
        });
      } else {
        return;
      }
    } on PostgrestException catch (error) {
      if (mounted) {
        SnackBar(
          content: Text(error.message),
          backgroundColor: Theme.of(context).colorScheme.error,
        );
      }
    } catch (error) {
      if (mounted) {
        SnackBar(
          content: const Text('Unexpected error occurred'),
          backgroundColor: Theme.of(context).colorScheme.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('eat.caias / '),
            Text(
              'stats',
              style: TextStyle(color: Colors.amber.shade800),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            mainPointsCard(points),
            const SizedBox(height: 10),
            ListTile(
              title: Row(
                children: [
                  const Text(
                    'Leaderboards / ',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'Top 10',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.amber.shade800,
                    ),
                  ),
                ],
              ),
            ),
            LeaderboardList(
              itemCount: leaderboardsTop10.length,
              content: leaderboardsTop10,
              titleFilter: "username",
              subtitleFilter: "points",
              subtitleLeadingText: "Points: ",
            ),
            ListTile(
              title: Row(
                children: [
                  const Text(
                    'Most Popular Canteen / ',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'Top 10',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.amber.shade800,
                    ),
                  ),
                ],
              ),
            ),
            LeaderboardList(
              itemCount: popularCanteenTop10.length,
              content: popularCanteenTop10,
              titleFilter: "shop_name",
              subtitleFilter: "order_count",
              subtitleLeadingText: "Orders: ",
            ),
            ListTile(
              title: Row(
                children: [
                  const Text(
                    'Most Ordered Food Item / ',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'Top 10',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.amber.shade800,
                    ),
                  ),
                ],
              ),
            ),
            LeaderboardList(
              itemCount: popularFoodItemTop10.length,
              content: popularFoodItemTop10,
              titleFilter: "item_name",
              subtitleFilter: "order_count",
              subtitleLeadingText: "Orders: ",
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.redeem_outlined),
        label: const Text("Redeem Points"),
      ),
    );
  }

  Widget mainPointsCard(int points) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Colors.amber.shade400,
          Colors.orange.shade400,
        ]),
      ),
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
              'You have $points eat.caias points',
              style: const TextStyle(
                fontSize: 22,
              ),
            ),
            subtitle: const Text(
              'Order more from our canteens, refer a friend to eat.caias, unlock achievements to earn more points!',
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }
}

class LeaderboardList extends StatelessWidget {
  const LeaderboardList({
    super.key,
    required this.itemCount,
    required this.content,
    required this.titleFilter,
    required this.subtitleFilter,
    required this.subtitleLeadingText,
  });

  final int itemCount;
  final List<Map<String, dynamic>> content;
  final String titleFilter;
  final String subtitleFilter;
  final String subtitleLeadingText;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 87,
      child: Padding(
        padding: cardPadding,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: itemCount,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                child: Container(
                  width: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.amber.shade100,
                        Colors.orange.shade100,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    tileColor: Colors.transparent,
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black12, width: 2)),
                      child: Text(
                        (index + 1).toString(),
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    title: Text(
                      content[index][titleFilter] as String,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      "$subtitleLeadingText ${content[index][subtitleFilter]}",
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
