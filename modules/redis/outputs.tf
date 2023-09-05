output "redis_cache_id" {
  description = "The ID of the Azure Redis Cache"
  value       = azurerm_redis_cache.redis.id
}
