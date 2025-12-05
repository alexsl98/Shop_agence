import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iconsax/iconsax.dart';
import 'package:latlong2/latlong.dart';
import 'package:shop_agence/src/core/theme/app_theme.dart';
import 'package:shop_agence/src/core/theme/text_styles.dart';
import 'package:shop_agence/src/presentation/provider/cart_provider/cart_provider.dart';
import 'package:shop_agence/src/presentation/provider/theme_provider/theme_provider.dart';
import 'package:shop_agence/src/presentation/widgets/custom_shimmer.dart';
import 'package:shop_agence/src/presentation/widgets/snack_bar.dart';

class MapScreenTest extends ConsumerStatefulWidget {
  const MapScreenTest({super.key});

  @override
  ConsumerState<MapScreenTest> createState() => _MapScreenTestState();
}

class _MapScreenTestState extends ConsumerState<MapScreenTest> {
  LatLng? myPosition;
  bool _isLoading = true;
  final MapController _mapController = MapController();

  // Lista de tile servers alternativos
  final List<Map<String, String>> tileServers = [
    {
      'name': 'OpenStreetMap FR (HOT)',
      'url': 'https://{s}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png',
      'subdomains': 'a,b,c',
    },
    {
      'name': 'OpenStreetMap DE',
      'url': 'https://{s}.tile.openstreetmap.de/{z}/{x}/{y}.png',
      'subdomains': 'a,b,c',
    },
    {
      'name': 'CartoDB Positron',
      'url': 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
      'subdomains': 'a,b,c',
    },
    {
      'name': 'Stadia Maps Alidade',
      'url':
          'https://tiles.stadiamaps.com/tiles/alidade_smooth/{z}/{x}/{y}{r}.png',
      'subdomains': 'a,b,c',
    },
    {
      'name': 'Wikimedia Maps',
      'url': 'https://maps.wikimedia.org/osm-intl/{z}/{x}/{y}.png',
      'subdomains': 'a,b,c',
    },
  ];

  int _currentTileIndex = 0;

  Future<Position> determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('error');
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  void getCurrentLocation() async {
    try {
      Position position = await determinePosition();
      setState(() {
        myPosition = LatLng(position.latitude, position.longitude);
        _isLoading = false;
        showSnackBar(
          context,
          '¡Ubicacion obtenida con exito!',
          type: SnackBarType.success,
        );
      });
    } catch (e) {
      showSnackBar(
        context,
        'Error obteniendo la ubicacion. Revise su conexión',
        type: SnackBarType.error,
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _changeTileServer() {
    setState(() {
      _currentTileIndex = (_currentTileIndex + 1) % tileServers.length;
      showSnackBar(
        context,
        'Cambiando a: ${tileServers[_currentTileIndex]['name']}',
        type: SnackBarType.info,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getCurrentLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);
    final appTheme = AppTheme(isDarkmode: isDarkMode);
    final cartItems = ref.watch(cartItemsProvider);
    final cartNotifier = ref.read(cartItemsProvider.notifier);

    final currentTile = tileServers[_currentTileIndex];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Ubicación',
              style: textAppBar.copyWith(color: appTheme.drawerForegroundColor),
            ),
            
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.green[200],
                borderRadius: BorderRadius.circular(8),
                ),
              child: IconButton(
                icon: const Icon(Iconsax.map, color: Colors.black,),
                onPressed: _changeTileServer,
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: ProductShimmerCard(),
            )
          : myPosition == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No se pudo obtener la ubicación',
                    style: TextStyle(color: appTheme.textSecondaryColor),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: getCurrentLocation,
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // Panel de coordenadas
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  color: appTheme.cardBackgroundColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Coordenadas',
                              style: TextStyle(
                                fontSize: 12,
                                color: appTheme.textSecondaryColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${myPosition!.latitude.toStringAsFixed(4)}, ${myPosition!.longitude.toStringAsFixed(4)}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: appTheme.textSecondaryColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: appTheme.cardBackgroundColor.withOpacity(
                                0.3,
                              ),
                            ),
                          ),
                          child: FlutterMap(
                            mapController: _mapController,
                            options: MapOptions(
                              center: myPosition,
                              minZoom: 5,
                              maxZoom: 19,
                              zoom: 15,
                            ),
                            children: [
                              TileLayer(
                                urlTemplate: currentTile['url']!,
                                subdomains: currentTile['subdomains']!.split(
                                  ',',
                                ),
                                userAgentPackageName: 'com.example.shop_agence',
                                tileProvider: NetworkTileProvider(),
                              ),

                              // Marcador de ubicación
                              MarkerLayer(
                                markers: [
                                  Marker(
                                    point: myPosition!,
                                    width: 50,
                                    height: 50,
                                    builder: (context) {
                                      return Icon(
                                        Iconsax.location,
                                        color: Colors.red,
                                        size: 20,
                                      );
                                    },
                                  ),
                                ],
                              ),
                              // Círculo para mostrar precisión de ubicación
                              CircleLayer(
                                circles: [
                                  CircleMarker(
                                    point: myPosition!,
                                    color: Colors.blue.withOpacity(0.1),
                                    borderColor: Colors.blue.withOpacity(0.4),
                                    borderStrokeWidth: 2,
                                    radius: 30,
                                    useRadiusInMeter: true,
                                  ),
                                ],
                              ),

                              // Controles de zoom
                              Positioned(
                                right: 16,
                                bottom: 16,
                                child: Column(
                                  children: [
                                    FloatingActionButton.small(
                                      heroTag: 'zoom_in',
                                      onPressed: () {
                                        _mapController.move(
                                          _mapController.center,
                                          _mapController.zoom + 1,
                                        );
                                      },
                                      child: const Icon(Icons.add),
                                    ),
                                    const SizedBox(height: 8),
                                    FloatingActionButton.small(
                                      heroTag: 'zoom_out',
                                      onPressed: () {
                                        _mapController.move(
                                          _mapController.center,
                                          _mapController.zoom - 1,
                                        );
                                      },
                                      child: const Icon(Icons.remove),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Contenido inferior (2/3 de la altura)
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Productos en el carrito',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: appTheme.textSecondaryColor,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Expanded(
                                child: _buildCartList(
                                  cartItems,
                                  cartNotifier,
                                  ref,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
      // Botón para centrar en ubicación
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _mapController.move(myPosition!, 15);
          showSnackBar(
            context,
            'Centrado en tu ubicación',
            type: SnackBarType.info,
          );
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }

  Widget _buildCartList(
    List<CartItem> cartItems,
    CartNotifier cartNotifier,
    WidgetRef ref,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.all(2),
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        final item = cartItems[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Imagen del producto
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    item.product.image,
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 70,
                      height: 70,
                      color: Colors.grey[200],
                      child: const Icon(
                        Iconsax.gallery_slash,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Información del producto
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.product.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                          fontSize: 15,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '\$${item.product.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.secondaryColor,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.product.description,
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
