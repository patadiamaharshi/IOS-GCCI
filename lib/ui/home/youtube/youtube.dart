import 'package:flutter/material.dart';
import 'package:gcci/common/common_toolbar.dart';
import 'package:provider/provider.dart';
import '../../../../common/circular_progress.dart';
import '../../../common/common_section.dart';
import '../../../common/dimension.dart';
import '../../../common/gcci_label.dart';
import '../../../utils/app_text_styles.dart';
import 'youtube_vm.dart';

class Youtube extends StatelessWidget {
  const Youtube({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => YoutubeViewModel(),
      child: const _Screen(),
    );
  }
}

class _Screen extends StatefulWidget {
  const _Screen();

  @override
  State<_Screen> createState() => _ScreenState();
}

class _ScreenState extends State<_Screen> {
  //final _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<YoutubeViewModel>().loadInitialData(context);
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        context.read<YoutubeViewModel>().getChannelVideos(loadMore: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<YoutubeViewModel>();

    return Scaffold(
      appBar: const CommonToolbar(title: "GCCI Videos"),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: CommonSection(
                    controller: _scrollController,
                    isLoading: vm.isLoading,
                    onRefresh: _onRefresh,
                    isEmpty: vm.video.isEmpty,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if(vm.errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Center(
                              child: GCCILabel(
                                  vm.errorMessage!,
                                  style: AppTextStyles.error
                              ),
                            ),
                          ),
                        videoSection(vm),
                      ],
                    ),
                  ),

                  /* child: GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        // top: 10,
                        bottom: 20,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if(vm.errorMessage != null)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Center(
                                  child: GCCILabel(
                                    vm.errorMessage!,
                                    style: AppTextStyles.error
                                  ),
                                ),
                              ),

                            videoSection(vm)],
                        ),
                      ),
                    ),
                  ),*/
                ),
              ],
            ),
            if (vm.isLoading)
              Center(child: CircularProgress(isLoading: vm.isLoading)),
          ],
        ),
      ),
    );
  }

  Widget videoSection(YoutubeViewModel vm) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 0, bottom: 0),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: vm.video.length,
      itemBuilder: (context, index) {
        final item = vm.video[index];

        return GestureDetector(
          onTap: () {
            vm.openYoutube(item["ID"] ?? '');
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (_) => YoutubePlayerScreen(
            //       videoId: item['ID'] ?? '',
            //     ),
            //   ),
            // );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 20),
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(5),
            //   border: Border.all(color: AppColor.buttonColor, width: 1),
            // ),
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Thumbnail
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      item['thumbnail'] ?? '',
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                  VerticalSpacer.medium,

                  /// Title
                  GCCILabel(
                    item['message'] ?? '',
                    style: AppTextStyles.label18,
                  ),

                  VerticalSpacer.normal,
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _onRefresh() async {
    await context.read<YoutubeViewModel>().loadInitialData(context);
  }
}
