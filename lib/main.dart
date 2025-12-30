import 'package:flutter/material.dart';

void main() {
  runApp(const CoffeeShopApp());
}

class CoffeeShopApp extends StatelessWidget {
  const CoffeeShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coffee Shop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto', // Default standard font
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFC67C4E),
          surface: const Color(0xFFF9F9F9),
        ),
        scaffoldBackgroundColor: const Color(0xFFF9F9F9),
      ),
      home: const WelcomePage(),
    );
  }
}

// 1. Welcome / Login Page
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1497935586351-b67a49e012bf?auto=format&fit=crop&q=80',
              fit: BoxFit.cover,
              color: Colors.black.withValues(alpha: 0.5),
              colorBlendMode: BlendMode.darken,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Time for a coffee break...',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Your daily dose of fresh brew delivered to your doorstep. Start your coffee journey now!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 48),
                // Login Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(isGuest: false),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC67C4E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Browse as Guest Button
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(isGuest: true),
                      ),
                    );
                  },
                  child: const Text(
                    'Browse as Guest',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 3. Home Page
class HomePage extends StatefulWidget {
  final bool isGuest;

  const HomePage({super.key, required this.isGuest});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Mock Data
  final List<Map<String, dynamic>> coffeeMenu = [
    {'name': 'Cappuccino', 'description': 'with Chocolate', 'price': 4.53, 'image': 'https://images.unsplash.com/photo-1578314675249-a6910f80cc4e?auto=format&fit=crop&q=80', 'category': 'Cappuccino'},
    {'name': 'Espresso', 'description': 'with Oat Milk', 'price': 3.90, 'image': 'https://images.unsplash.com/photo-1517701550927-30cf4ba1dba5?auto=format&fit=crop&q=80', 'category': 'Espresso'},
    {'name': 'Latte', 'description': 'with Almond Milk', 'price': 4.20, 'image': 'https://images.unsplash.com/photo-1517701550927-30cf4ba1dba5?auto=format&fit=crop&q=80', 'category': 'Latte'},
    {'name': 'Mocha', 'description': 'Double Shot', 'price': 5.00, 'image': 'https://images.unsplash.com/photo-1578314675249-a6910f80cc4e?auto=format&fit=crop&q=80', 'category': 'Mocha'},
  ];

  // 2. ตัวแปรสำหรับเก็บสถานะการ Search และ Filter
  List<Map<String, dynamic>> displayedMenu = [];
  String searchQuery = "";
  String selectedCategory = "All"; // เริ่มต้นที่ All

  final List<String> categories = ['All', 'Cappuccino', 'Espresso', 'Latte', 'Mocha'];

  @override
  void initState() {
    super.initState();
    displayedMenu = coffeeMenu; // เริ่มต้นให้แสดงทั้งหมด
  }

  // 3. ฟังก์ชันหลักในการกรองข้อมูล
  void _filterCoffee() {
    setState(() {
      displayedMenu = coffeeMenu.where((coffee) {
        final matchesSearch = coffee['name'].toLowerCase().contains(searchQuery.toLowerCase());
        final matchesCategory = selectedCategory == "All" || coffee['category'] == selectedCategory;
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  void _addToCart() {
    if (widget.isGuest) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Member Only'),
          content: const Text('กรุณา Login เพื่อสะสมแต้ม'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC67C4E)),
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back to Welcome/Login
              },
              child: const Text('Go to Login',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Added to cart!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Location',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: const [
                          Text(
                            'Bangkok, Thailand',
                            style: TextStyle(
                              color: Color(0xFF2F2D2C),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Icon(Icons.keyboard_arrow_down,
                              color: Color(0xFF2F2D2C)),
                        ],
                      ),
                    ],
                  ),
                  // User Status
                  widget.isGuest
                      ? InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const WelcomePage(),
                              ),
                            );
                          },
                          child: const Text(
                            'Login to earn points',
                            style: TextStyle(
                              color: Color(0xFFC67C4E),
                              fontWeight: FontWeight.bold,
                              fontSize: 12
                            ),
                          ),
                        )
                      : Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: const [
                                Text(
                                  'BeeBoo',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2F2D2C),
                                  ),
                                ),
                                Text(
                                  'Points: 120',
                                  style: TextStyle(
                                    color: Color(0xFFC67C4E),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 8),
                            const CircleAvatar(
                              backgroundColor: Colors.grey,
                              backgroundImage: NetworkImage(
                                  'https://i.pravatar.cc/150?img=12'),
                            ),
                          ],
                        ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: const Color(0xFF313131),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        onChanged: (value) {
                          searchQuery = value;
                          _filterCoffee();
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search coffee',
                          hintStyle: TextStyle(color: Colors.grey),
                          icon: Icon(Icons.search, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    height: 52,
                    width: 52,
                    decoration: BoxDecoration(
                      color: const Color(0xFFC67C4E),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.tune, color: Colors.white),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Categories (Filter)
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return _buildCategoryChip(categories[index],
                      selectedCategory == categories[index]);
                },
              ),
            ),

            const SizedBox(height: 24),

            // Grid View (ใช้ displayedMenu แทน coffeeMenu)
            Expanded(
              child: displayedMenu.isEmpty
                  ? const Center(child: Text("No coffee found :("))
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: displayedMenu.length,
                      itemBuilder: (context, index) {
                        final item = displayedMenu[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailPage(item: item),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Image
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      item['image'],
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Container(
                                        color: Colors.grey[300],
                                        child: const Icon(Icons.coffee,
                                            size: 50, color: Colors.brown),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                // Title
                                Text(
                                  item['name'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2F2D2C),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                // Subtitle
                                Text(
                                  item['description'],
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                // Price and Add Button
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '\$${item['price'].toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF2F2D2C),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: _addToCart,
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFC67C4E),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: const Icon(Icons.add,
                                            color: Colors.white, size: 20),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: const Color(0xFFC67C4E),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: 'Favorite'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag), label: 'Cart'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: 'Notifications'),
        ],
      ),
    );
  }

  // Widget แยกเพื่อความสะอาดของโค้ด
  Widget _buildCategoryChip(String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        selectedCategory = label;
        _filterCoffee();
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFC67C4E) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? null : Border.all(color: Colors.grey.shade300),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

// 4. Detail Page
class DetailPage extends StatefulWidget {
  final Map<String, dynamic> item;

  const DetailPage({super.key, required this.item});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String selectedSize = 'M';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: Text(widget.item['name'],
            style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Image Area
            Center(
              child: Container(
                margin: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 20,
                      spreadRadius: 5,
                    )
                  ],
                ),
                child: ClipOval(
                  child: Image.network(
                    widget.item['image'],
                    width: 280,
                    height: 280,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 280,
                      height: 280,
                      color: Colors.grey[300],
                      child: const Icon(Icons.coffee,
                          size: 80, color: Colors.brown),
                    ),
                  ),
                ),
              ),
            ),
            // Details Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Description
                  Text(
                    widget.item['name'],
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2F2D2C)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.item['description'],
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 16),

                  // Rating
                  Row(
                    children: const [
                      Icon(Icons.star, color: Colors.amber, size: 24),
                      SizedBox(width: 8),
                      Text("4.5",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(width: 4),
                      Text("(2,330)", style: TextStyle(color: Colors.grey)),
                    ],
                  ),

                  const SizedBox(height: 24),
                  const Divider(color: Color(0xFFEAEAEA)),
                  const SizedBox(height: 24),

                  // Description Body
                  const Text("Description",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  const Text(
                    "A cappuccino is an approximately 150 ml (5 oz) beverage, with 25 ml of espresso coffee and 85ml of fresh milk the fo.. Read More",
                    style: TextStyle(color: Colors.grey, height: 1.5),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 24),

                  // Size Selection
                  const Text("Size",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildSizeChip("S"),
                      _buildSizeChip("M"),
                      _buildSizeChip("L"),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Price", style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 4),
                Text(
                  '\$${widget.item['price'].toStringAsFixed(2)}',
                  style: const TextStyle(
                      color: Color(0xFFC67C4E),
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC67C4E),
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text("Buy Now",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSizeChip(String size) {
    bool isSelected = selectedSize == size;
    return GestureDetector(
      onTap: () => setState(() => selectedSize = size),
      child: Container(
        width: 90,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFF5EE) : Colors.white,
          border: Border.all(
              color: isSelected
                  ? const Color(0xFFC67C4E)
                  : Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(
          size,
          style: TextStyle(
            color: isSelected ? const Color(0xFFC67C4E) : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
