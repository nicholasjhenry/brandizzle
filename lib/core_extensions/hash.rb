class HashWithIndifferentAccess
  def rewrite(mapping)
    inject({}) do |rewritten_hash, (original_key, value)|
      rewritten_hash[(mapping.with_indifferent_access[original_key] || original_key)] = value
      rewritten_hash
    end
  end
end
