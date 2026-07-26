import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rav_365_photo_editor/widgets/tool_bar.dart';

import 'providers/photo_provider.dart';
import 'widgets/title_bar.dart';
import 'widgets/menu_bar.dart';
import 'widgets/left_sidebar.dart';
import 'widgets/center_workspace.dart';
import 'widgets/right_sidebar.dart';
import 'widgets/filmstrip.dart';
import 'widgets/status_bar.dart';
import 'widgets/splash_screen.dart';

void main() {
  runApp(const Rav365PhotoEditor());

  // BitsDojo Window Desktop Configuration for Windows
  doWhenWindowReady(() {
    const initialSize = Size(1200, 600);
    const minSize = Size(1200, 600);
    appWindow.minSize = minSize;
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.title = 'Rav 365 Photo Editor';
    appWindow.show();
  });
}

class Rav365PhotoEditor extends StatelessWidget {
  const Rav365PhotoEditor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PhotoProvider()),
      ],
      child: MaterialApp(
        title: 'Rav365PhotoEditor',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: const Color(0xFF1E1E1E),
          cardColor: const Color(0xFF262626),
          canvasColor: const Color(0xFF262626),
          dialogBackgroundColor: const Color(0xFF2B2B2B),
          textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF0078D4),
            secondary: Color(0xFF00A2ED),
            surface: Color(0xFF262626),
            background: Color(0xFF1E1E1E),
          ),
        ),
        home: const LuminaMainScreen(),
      ),
    );
  }
}

class LuminaMainScreen extends StatelessWidget {
  const LuminaMainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PhotoProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                // 1. Custom Windows Title Bar
                const LuminaTitleBar(),

                // 2. Menu Bar
                const LuminaMenuBar(),

                // 3. Quick Action Toolbar
                const LuminaToolbar(),

                // 4. Main 3-Panel Workspace
                Expanded(
                  child: Row(
                    children: [
                      // Left Navigation Sidebar
                      if (provider.showLeftSidebar) const LuminaLeftSidebar(),

                      // Center Image Workspace Canvas
                      const Expanded(child: LuminaCenterWorkspace()),

                      // Right EXIF Inspector Panel
                      if (provider.showRightSidebar) const LuminaRightSidebar(),
                    ],
                  ),
                ),

                // 5. Filmstrip
                if (provider.showFilmstrip) const LuminaFilmstrip(),

                // 6. Status Bar
                const LuminaStatusBar(),
              ],
            ),
          ),

          if (provider.showSplash)
            LuminaSplashScreen(
              onFinish: () => provider.hideSplash(),
            ),
        ],
      ),
    );
  }
}
