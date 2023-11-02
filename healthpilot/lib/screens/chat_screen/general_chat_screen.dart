import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GeneralChatScreen extends StatefulWidget {
  const GeneralChatScreen({super.key});

  @override
  State<GeneralChatScreen> createState() => _GeneralChatScreenState();
}

class _GeneralChatScreenState extends State<GeneralChatScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 3, initialIndex: 0, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
              toolbarHeight: 70,
              elevation: 0,
              backgroundColor: Colors.white,
              title: _buildTabBar()),
          floatingActionButton: _buildFloatingActionButton(),
          body: Column(children: [
            _buildSearchBar(),
            const Expanded(
              child: TabBarView(children: [
                Text('All'),
                Text('People'),
                Text('Groups'),
              ]),
            )
          ]),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.only(left: 29.0.w, right: 23.w, top: 37),
      child: TextFormField(
        decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.search,
              size: 40,
            ),
            hintText: 'Search Chats',
            hintStyle: TextStyle(
              color: const Color.fromRGBO(193, 193, 193, 1),
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 14.sp,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w400,
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                    width: 1, color: Color.fromRGBO(217, 217, 217, 1)))),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {},
      backgroundColor: const Color.fromRGBO(110, 182, 255, 1),
      child: const Icon(
        Icons.person_search_outlined,
        size: 30,
      ),
    );
  }

  TabBar _buildTabBar() {
    return TabBar(
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: Colors.black,
        unselectedLabelStyle: TextStyle(
          color: const Color.fromRGBO(42, 42, 42, 1),
          fontFamily: 'Plus Jakarta Sans',
          fontSize: 16.sp,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.165.sp,
        ),
        labelStyle: TextStyle(
          color: const Color.fromRGBO(42, 42, 42, 1),
          fontFamily: 'Plus Jakarta Sans',
          fontSize: 16.sp,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.165.sp,
        ),
        // controller: _tabController,
        indicatorColor: Theme.of(context).colorScheme.primary,
        tabs: const [
          Tab(
            text: 'All',
          ),
          Tab(
            text: 'People',
          ),
          Tab(
            text: 'Groups',
          ),
        ]);
  }
}
