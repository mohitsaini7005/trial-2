import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lali/core/constants/colors.dart';

class CustomSearchBar extends StatefulWidget {
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;
  final VoidCallback? onMicTap;
  final bool showFilter;
  final bool showMic;
  final TextEditingController? controller;

  const CustomSearchBar({
    Key? key,
    this.hintText,
    this.onChanged,
    this.onFilterTap,
    this.onMicTap,
    this.showFilter = true,
    this.showMic = false,
    this.controller,
  }) : super(key: key);

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: _isFocused 
                    ? AppColors.tribalPrimary 
                    : AppColors.lightGrey.withOpacity(0.5),
                width: _isFocused ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: _isFocused 
                      ? AppColors.tribalPrimary.withOpacity(0.1) 
                      : Colors.grey.withOpacity(0.05),
                  blurRadius: _isFocused ? 12 : 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                const SizedBox(width: 16),
                Icon(
                  Icons.search,
                  color: _isFocused 
                      ? AppColors.tribalPrimary 
                      : AppColors.grey,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: widget.controller,
                    onChanged: widget.onChanged,
                    onTap: () {
                      setState(() {
                        _isFocused = true;
                      });
                      _animationController.forward();
                    },
                    onTapOutside: (_) {
                      setState(() {
                        _isFocused = false;
                      });
                      _animationController.reverse();
                    },
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: AppColors.tribalText,
                    ),
                    decoration: InputDecoration(
                      hintText: widget.hintText ?? 'Search...',
                      hintStyle: GoogleFonts.inter(
                        fontSize: 16,
                        color: AppColors.grey.withOpacity(0.7),
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                if (widget.showMic) ...[
                  GestureDetector(
                    onTap: widget.onMicTap,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.tribalSecondary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.mic_outlined,
                        color: AppColors.tribalSecondary,
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                if (widget.showFilter) ...[
                  GestureDetector(
                    onTap: widget.onFilterTap,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.tune,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class FloatingSearchBar extends StatefulWidget {
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool isCollapsed;
  final List<Widget>? suggestions;

  const FloatingSearchBar({
    Key? key,
    this.hintText,
    this.onChanged,
    this.onTap,
    this.isCollapsed = false,
    this.suggestions,
  }) : super(key: key);

  @override
  State<FloatingSearchBar> createState() => _FloatingSearchBarState();
}

class _FloatingSearchBarState extends State<FloatingSearchBar>
    with TickerProviderStateMixin {
  late AnimationController _expandController;
  late AnimationController _fadeController;
  late Animation<double> _expandAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _expandController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _expandAnimation = CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeInOut,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    if (!widget.isCollapsed) {
      _expandController.forward();
      _fadeController.forward();
    }
  }

  @override
  void didUpdateWidget(FloatingSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isCollapsed != oldWidget.isCollapsed) {
      if (widget.isCollapsed) {
        _fadeController.reverse().then((_) {
          _expandController.reverse();
        });
      } else {
        _expandController.forward().then((_) {
          _fadeController.forward();
        });
      }
    }
  }

  @override
  void dispose() {
    _expandController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _expandAnimation,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: AppColors.tribalPrimary.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 56,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: AppColors.tribalPrimary,
                      size: 24,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: TextField(
                          onChanged: widget.onChanged,
                          onTap: widget.onTap,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: AppColors.tribalText,
                          ),
                          decoration: InputDecoration(
                            hintText: widget.hintText ?? 'Search destinations, stays, events...',
                            hintStyle: GoogleFonts.inter(
                              fontSize: 16,
                              color: AppColors.grey,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.suggestions != null && widget.suggestions!.isNotEmpty)
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SizeTransition(
                    sizeFactor: _expandAnimation,
                    child: Container(
                      constraints: const BoxConstraints(maxHeight: 200),
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(8),
                        itemCount: widget.suggestions!.length,
                        itemBuilder: (context, index) => widget.suggestions![index],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class SearchSuggestionTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final VoidCallback? onTap;

  const SearchSuggestionTile({
    Key? key,
    required this.title,
    this.subtitle,
    this.icon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.tribalSecondary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon ?? Icons.location_on_outlined,
          color: AppColors.tribalSecondary,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.tribalText,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.grey,
              ),
            )
          : null,
      trailing: const Icon(
        Icons.north_west,
        color: AppColors.grey,
        size: 16,
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}