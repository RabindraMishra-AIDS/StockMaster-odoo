import { useEffect, useState } from 'react'
import { supabase } from '../config/supabase'
import { Card } from '../components/ui/Card'
import { Button } from '../components/ui/Button'
import { Input, Select, TextArea } from '../components/ui/Input'
import { Modal } from '../components/ui/Modal'
import { Badge } from '../components/ui/Badge'
import { Loading } from '../components/ui/Loading'
import { Alert } from '../components/ui/Alert'
import { Plus, TrendingUp, TrendingDown, RefreshCw } from 'lucide-react'
import { format } from 'date-fns'

export default function StockMovement() {
  const [movements, setMovements] = useState([])
  const [products, setProducts] = useState([])
  const [loading, setLoading] = useState(true)
  const [modalOpen, setModalOpen] = useState(false)
  const [error, setError] = useState('')
  const [success, setSuccess] = useState('')
  
  const [formData, setFormData] = useState({
    product_id: '',
    type: 'in',
    quantity: 0,
    notes: ''
  })

  useEffect(() => {
    fetchData()
  }, [])

  const fetchData = async () => {
    try {
      // Fetch stock movements
      const { data: movementsData, error: movementsError } = await supabase
        .from('stock_movements')
        .select(`
          *,
          products(id, name, sku)
        `)
        .order('created_at', { ascending: false })
        .limit(100)
      
      if (movementsError) throw movementsError
      setMovements(movementsData || [])

      // Fetch products
      const { data: productsData } = await supabase
        .from('products')
        .select('id, name, sku, quantity')
      setProducts(productsData || [])

    } catch (error) {
      console.error('Error fetching data:', error)
      setError('Failed to load stock movements')
    } finally {
      setLoading(false)
    }
  }

  const handleOpenModal = () => {
    setFormData({
      product_id: '',
      type: 'in',
      quantity: 0,
      notes: ''
    })
    setModalOpen(true)
  }

  const handleCloseModal = () => {
    setModalOpen(false)
    setError('')
  }

  const handleSubmit = async (e) => {
    e.preventDefault()
    setError('')
    
    try {
      // Insert stock movement
      const { error: insertError } = await supabase
        .from('stock_movements')
        .insert([{
          ...formData,
          quantity: parseInt(formData.quantity)
        }])
      
      if (insertError) throw insertError

      // Update product quantity
      const product = products.find(p => p.id === formData.product_id)
      if (!product) throw new Error('Product not found')

      let newQuantity = product.quantity
      if (formData.type === 'in') {
        newQuantity += parseInt(formData.quantity)
      } else if (formData.type === 'out') {
        newQuantity -= parseInt(formData.quantity)
        if (newQuantity < 0) throw new Error('Insufficient stock')
      }

      const { error: updateError } = await supabase
        .from('products')
        .update({ quantity: newQuantity })
        .eq('id', formData.product_id)
      
      if (updateError) throw updateError
      
      setSuccess('Stock movement recorded successfully!')
      handleCloseModal()
      fetchData()
      setTimeout(() => setSuccess(''), 3000)
    } catch (error) {
      console.error('Error saving stock movement:', error)
      setError(error.message || 'Failed to save stock movement')
    }
  }

  const getMovementIcon = (type) => {
    switch (type) {
      case 'in': return <TrendingUp size={20} className="text-green-600" />
      case 'out': return <TrendingDown size={20} className="text-red-600" />
      default: return null
    }
  }

  const getMovementBadge = (type) => {
    switch (type) {
      case 'in': return <Badge variant="success">Stock In</Badge>
      case 'out': return <Badge variant="danger">Stock Out</Badge>
      default: return null
    }
  }

  if (loading) return <Loading size="lg" />

  // Separate movements by type
  const stockInMovements = movements.filter(m => m.type === 'in')
  const stockOutMovements = movements.filter(m => m.type === 'out')

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h1 className="text-4xl font-black uppercase">Stock Movement</h1>
        <Button variant="primary" onClick={handleOpenModal} className="flex items-center gap-2">
          <Plus size={20} />
          <span>Record Movement</span>
        </Button>
      </div>

      {error && <Alert variant="danger" onClose={() => setError('')}>{error}</Alert>}
      {success && <Alert variant="success" onClose={() => setSuccess('')}>{success}</Alert>}

      {/* Side-by-Side Stock In and Stock Out */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Stock In Section */}
        <Card className="bg-green-50">
          <div className="flex items-center gap-3 mb-4">
            <div className="p-3 bg-green-500 border-2 border-black">
              <TrendingUp size={24} color="white" />
            </div>
            <h2 className="text-2xl font-bold uppercase">Stock In</h2>
          </div>
          
          <div className="space-y-3 max-h-[600px] overflow-y-auto pr-2">
            {stockInMovements.length === 0 ? (
              <p className="text-center font-bold text-gray-500 py-8">No stock in movements yet</p>
            ) : (
              stockInMovements.map((movement) => (
                <div 
                  key={movement.id}
                  className="p-3 border-2 border-black bg-white"
                >
                  <div className="flex items-start justify-between mb-2">
                    <div>
                      <h3 className="font-bold">{movement.products?.name}</h3>
                      <p className="text-xs text-gray-600">SKU: {movement.products?.sku}</p>
                    </div>
                    <Badge variant="success">+{movement.quantity}</Badge>
                  </div>
                  
                  <div className="text-xs text-gray-600 mb-1">
                    <span className="font-bold">Date:</span> {format(new Date(movement.created_at), 'MMM dd, yyyy HH:mm')}
                  </div>
                  
                  {movement.notes && (
                    <div className="text-xs text-gray-600">
                      <span className="font-bold">Notes:</span> {movement.notes}
                    </div>
                  )}
                </div>
              ))
            )}
          </div>
        </Card>

        {/* Stock Out Section */}
        <Card className="bg-red-50">
          <div className="flex items-center gap-3 mb-4">
            <div className="p-3 bg-red-500 border-2 border-black">
              <TrendingDown size={24} color="white" />
            </div>
            <h2 className="text-2xl font-bold uppercase">Stock Out</h2>
          </div>
          
          <div className="space-y-3 max-h-[600px] overflow-y-auto pr-2">
            {stockOutMovements.length === 0 ? (
              <p className="text-center font-bold text-gray-500 py-8">No stock out movements yet</p>
            ) : (
              stockOutMovements.map((movement) => (
                <div 
                  key={movement.id}
                  className="p-3 border-2 border-black bg-white"
                >
                  <div className="flex items-start justify-between mb-2">
                    <div>
                      <h3 className="font-bold">{movement.products?.name}</h3>
                      <p className="text-xs text-gray-600">SKU: {movement.products?.sku}</p>
                    </div>
                    <Badge variant="danger">-{movement.quantity}</Badge>
                  </div>
                  
                  <div className="text-xs text-gray-600 mb-1">
                    <span className="font-bold">Date:</span> {format(new Date(movement.created_at), 'MMM dd, yyyy HH:mm')}
                  </div>
                  
                  {movement.notes && (
                    <div className="text-xs text-gray-600">
                      <span className="font-bold">Notes:</span> {movement.notes}
                    </div>
                  )}
                </div>
              ))
            )}
          </div>
        </Card>
      </div>

      {/* Stock Movement Modal */}
      <Modal
        isOpen={modalOpen}
        onClose={handleCloseModal}
        title="Record Stock Movement"
        footer={
          <>
            <Button variant="default" onClick={handleCloseModal}>
              Cancel
            </Button>
            <Button variant="primary" onClick={handleSubmit}>
              Record
            </Button>
          </>
        }
      >
        <form onSubmit={handleSubmit}>
          <Select
            label="Product"
            value={formData.product_id}
            onChange={(e) => setFormData({ ...formData, product_id: e.target.value })}
            required
          >
            <option value="">Select Product</option>
            {products.map((product) => (
              <option key={product.id} value={product.id}>
                {product.name} ({product.sku}) - Current: {product.quantity}
              </option>
            ))}
          </Select>

          <Select
            label="Movement Type"
            value={formData.type}
            onChange={(e) => setFormData({ ...formData, type: e.target.value })}
            required
          >
            <option value="in">Stock In (Add)</option>
            <option value="out">Stock Out (Remove)</option>
          </Select>

          <Input
            type="number"
            label="Quantity"
            value={formData.quantity}
            onChange={(e) => setFormData({ ...formData, quantity: e.target.value })}
            required
            min="0"
          />

          <TextArea
            label="Notes"
            value={formData.notes}
            onChange={(e) => setFormData({ ...formData, notes: e.target.value })}
            placeholder="Additional notes..."
          />
        </form>
      </Modal>
    </div>
  )
}
